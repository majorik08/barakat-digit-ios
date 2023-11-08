//
//  NetworkClient.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import Alamofire
import UIKit

class APIManager {
    
    public enum Authentication {
        case noAuth
        case auth
    }
    
    let encodeError = NetworkError(message: "encodeError", error: "-1111")
    let decodeError = NetworkError(message: "decodeError", error: "-1112")
    let networkError = NetworkError(message: "networkError", error: "-1113")
    
    enum ServerErrors: String, Codable {
    case expiredToken = "0x000"
    case registrationData = "0x001"
    case ConfirmData = "1x001"
    case ConfirmDeviceNotFound = "1x002"
    case ConfirmInvalidCode = "1x003"
    case ConfirmWentWrong = "1x004"
    case ConfirmDeviceBlocked = "1x005"
    case PinCodeDeviceNotFound = "2x002"
    case UpdateDeviceData = "3x001"
    case UpdateDeviceInternal = "3x002"
    case ResourceNotFound = "4x001"
    }
    
    static let instance = APIManager()
    
    private let sessionManager: Alamofire.Session
    private let queue = DispatchQueue(label: "download_queue")
    private let rootPath: String
    private let cachePath: String
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private var reachability: NetworkReachabilityManager
    
    public var isReachable: Bool { return self.reachability.isReachable }
    public var isReachableOnCellular: Bool { return self.reachability.isReachableOnCellular }
    public var isReachableOnEthernetOrWiFi: Bool { return self.reachability.isReachableOnEthernetOrWiFi }
    
    private var token: String? = nil
    private var tokenUpdateRetry: Int = 0
    
    private init() {
        self.rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        self.cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        self.sessionManager = Session(configuration: URLSessionConfiguration.af.default, rootQueue: self.queue, startRequestsImmediately: true, eventMonitors: [])
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .millisecondsSince1970
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .millisecondsSince1970
        self.reachability = NetworkReachabilityManager()!
        self.reachability.startListening(onUpdatePerforming: self.network(onUpdatePerforming:))
    }
    
    private func network(onUpdatePerforming: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch onUpdatePerforming {
        case .notReachable:
            Logger.log(tag: "NetworkClient", message: "notReachable")
        case .reachable(_), .unknown:
            Logger.log(tag: "NetworkClient", message: "reachable")
        }
    }
    
    public func setToken(token: String) {
        self.token = token
        print(token)
    }
    
    public func headers(auth: Authentication) -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Accept", value: "application/json")
        headers.add(name: "Content-Type", value: "application/json")
        guard let tkn = self.token, auth == .auth else { return headers }
        headers.update(name: "Authorization", value: "Bearer \(tkn)")
        return headers
    }
    
    public func fileHeaders(auth: Authentication) -> HTTPHeaders {
        var headers = HTTPHeaders()
        guard let tkn = self.token, auth == .auth else { return headers }
        headers.update(name: "Authorization", value: "Bearer \(tkn)")
        return headers
    }
    
    public func request<Params: Codable, Response: Codable>(_ request: EndpointRequest<Params, Response>, auth: Authentication = .noAuth, timeOut: Int64 = 30, completion: @escaping ((_ T: ResponseModel<Response>) -> Void)) {
        guard let data = try? self.encoder.encode(request.params) else {
            let requestEncodeError: ResponseModel<Response> = ResponseModel(result: .failure(self.encodeError))
            completion(requestEncodeError)
            return
        }
        var req = URLRequest(url: URL(string: "\(Constants.ApiUrl)\(request.url)")!)
        req.httpMethod = request.method.rawValue
        req.headers = self.headers(auth: auth)
        req.timeoutInterval = TimeInterval(timeOut)
        if req.method != .get {
            req.httpBody = data
        }
        AF.request(req).responseData { resp in
            let requestDecodeError: ResponseModel<Response> = ResponseModel(result: .failure(self.decodeError))
            switch resp.result {
            case .success(let data):
                Logger.log(tag: "NetworkClient", message: "http: \(String(data: data, encoding: .utf8) ??  "")")
                do {
                    let natsResp = try self.decoder.decode(ResponseModel<Response>.self, from: data)
                    if case Result.failure(let networkError) = natsResp.result {
                        self.checkRefreshToken(error: networkError.error)
                    }
                    completion(natsResp)
                } catch {
                    Logger.log(tag: "NetworkClient", error: error)
                    completion(requestDecodeError)
                }
            case .failure(let error):
                Logger.log(tag: "NetworkClient", error: error, send: true)
                guard let data = resp.data else {
                    let networkError: ResponseModel<Response> = .init(result: .failure(.init(message: error.localizedDescription, error: String(describing: resp.response?.statusCode))))
                    completion(networkError)
                    return
                }
                do {
                    let natsResp = try self.decoder.decode(NetworkError.self, from: data)
                    self.checkRefreshToken(error: natsResp.error)
                    completion(.init(result: .failure(natsResp)))
                } catch {
                    Logger.log(tag: "NetworkClient", error: error)
                    completion(requestDecodeError)
                }
            }
        }
    }
    
    func checkRefreshToken(error: String?) {
        guard let error = error, error == ServerErrors.expiredToken.rawValue else { return }
        guard self.tokenUpdateRetry < 2 else { return }
        guard let token = self.token else { return }
        guard let account = CoreAccount.accounts().first(where: { $0.token == token }) else { return }
        self.tokenUpdateRetry += 1
        self.request(.init(AppMethods.Auth.RefreshToken(.init())), auth: .auth) { response in
            switch response.result {
            case .success(let token):
                self.token = token.token
                account.token = token.token
                account.update()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    public enum ImageSize: String {
        case original = ""
        case small = "small"
        case medium = "medium"
        case large = "large"
        case thumbnail = "thumbnail"
    }
    
    public enum FileType: String {
        case image = "Image"
        case document = "Document"
        
        public var defaultExt: String {
            switch self {
            case .image: return "jpeg"
            case .document: return "file"
            }
        }
    }
    
    struct UploadResult: Codable {
        var code: String
        var message: String
    }
    
    func startDownload() {
//        let req = self.sessionManager.download("\(Constants.ApiUrl)/files/file", method: .get, headers: headers, to: { _, _ in
//            return (to, [.removePreviousFile, .createIntermediateDirectories])
//        }).downloadProgress(queue: session.rootQueue, closure: { progress in
//            print("progress: \(progress.fractionCompleted)")
//        }).response(queue: session.rootQueue, completionHandler: { response in
//            switch response.result {
//            case .success(_):
//                if let code = response.response?.statusCode, code == 200 {
//                    self.status = .finished(result: self.localUrl.absoluteString)
//                } else {
//                    self.status = .error(error: AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.response?.statusCode ?? -1)))
//                }
//            case .failure(let afError):
//                self.status = .error(error: afError)
//            }
//        })
//        self.requests.append(req)
    }
    
    func startUpload(file: URL, completion: @escaping ((_ result: String?) -> Void)) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(file, withName: "file", fileName: file.lastPathComponent, mimeType: "image/jpeg")
        }, to: "\(Constants.ApiUrl)/files/file", method: .post, headers: self.fileHeaders(auth: .auth))
        .uploadProgress { progress in
            print("progress: \(progress.fractionCompleted)")
        }.responseData { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let dec = JSONDecoder()
                    let result = try dec.decode([UploadResult].self, from: data)
                    completion(result.first?.message)
                } catch {
                    debugPrint(error)
                    Logger.log(tag: "Task", message: "upload response \(String(describing: String(data: data, encoding: .utf8)))")
                }
            case .failure(let afError):
                Logger.log(error: afError)
                completion(nil)
            }
        }
    }
    
    @discardableResult
    private func getPath(for fileType: FileType) -> String {
        if let url = URL(string: self.rootPath) {
            let path = url.appendingPathComponent(fileType.rawValue)
            if FileManager.default.fileExists(atPath: path.path) {
                return path.path
            } else {
                do {
                    try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: false, attributes: nil)
                    return path.path
                } catch {
                    Logger.log(tag: "getPath", error: error, send: true)
                }
            }
        }
        return self.cachePath
    }
    
    public func getFileUrl(type: FileType, name: String, size: ImageSize) -> URL {
        let name = name.replacingOccurrences(of: ":", with: "_")
        let dir = self.getPath(for: type)
        let path = "\(dir)/\(size.rawValue)_\(name)"
        return URL(fileURLWithPath: path)
    }
    
    public func getFileUrl(type: FileType, name: String, size: ImageSize, mimeType: String?) -> URL {
        let ext = extensionFor(mime: mimeType) ?? type.defaultExt
        let name = name.replacingOccurrences(of: ":", with: "_")
        let dir = self.getPath(for: type)
        let path = "\(dir)/\(size.rawValue)_\(name).\(ext)"
        return URL(fileURLWithPath: path)
    }
    
    public func getFileUrl(type: FileType, name: String) -> URL {
        let name = name.replacingOccurrences(of: ":", with: "_")
        let dir = self.getPath(for: type)
        let path = "\(dir)/\(name)"
        return URL(fileURLWithPath: path)
    }
    
    public func getNewFileName(type: FileType, mimeType: String?) -> String {
        let ext = extensionFor(mime: mimeType) ?? type.defaultExt
        return "\(UUID().uuidString).\(ext)"
    }
    
    @discardableResult
    public func moveFile(url: URL, to: URL) -> Bool {
        do {
            try FileManager.default.moveItem(at: url, to: to)
            return true
        } catch {
            Logger.log(tag: "moveFile", error: error, send: true)
        }
        return false
    }
    
    @discardableResult
    public func deleteFile(url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: url.path)
            return true
        } catch {
            Logger.log(tag: "deleteFile", error: error, send: true)
        }
        return false
    }
    
    public func saveDataTemp(data: Data) -> URL? {
        let filePath = "\(self.cachePath)/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: filePath)
        do {
            try data.write(to: url)
            return url
        } catch {
            Logger.log(tag: "saveDataTemp", error: error, send: true)
        }
        return nil
    }
    
    public func fileExist(filename: String, fileType: FileType) -> Bool {
        return FileManager.default.fileExists(atPath: self.getFileUrl(type: fileType, name: filename).path)
    }
    
    public func fileExist(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    @discardableResult
    public class func saveImageLocal(scaledImage: UIImage, compress: Bool, url: URL) -> Bool {
        guard let data = compress ? scaledImage.compressImage() : scaledImage.jpegData(compressionQuality: 1) else {
            return false
        }
        do {
            try data.write(to: url)
            return true
        } catch {
            Logger.log(tag: "saveImageLocal", error: error, send: true)
        }
        return false
    }

    @discardableResult
    public class func saveImagePngLocal(image: UIImage, url: URL) -> Bool {
        guard let data = image.pngData() ?? image.jpegData(compressionQuality: 1.0) else { return false }
        do {
            try data.write(to: url)
            return true
        } catch {
            Logger.log(tag: "saveImagePngLocal", error: error, send: true)
            return false
        }
    }

    @discardableResult
    public class func saveDataLocal(data: Data, url: URL) -> Bool {
        do {
            try data.write(to: url)
            return true
        } catch {
            Logger.log(tag: "saveDataLocal", error: error, send: true)
            return false
        }
    }
}
