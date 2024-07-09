//
//  NetworkClient.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import Alamofire
import UIKit

public protocol ImageSet {
    func setImage(image: UIImage?)
    func loadFailed()
}

class APIManager {
    
    public enum Authentication {
        case noAuth
        case auth
    }
    
    public static let encodeError = NetworkError(message: "encodeError", error: "-1111")
    public static let decodeError = NetworkError(message: "decodeError", error: "-1112")
    public static let networkError = NetworkError(message: "networkError", error: "-1113")
    public static let uploadError = NetworkError(message: "uploadError", error: "-1114")
    public static let downloadError = NetworkError(message: "downloadError", error: "-1115")
    
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
    
    public func setToken(token: String?) {
        self.token = token
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
            let requestEncodeError: ResponseModel<Response> = ResponseModel(result: .failure(Self.encodeError))
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
        Logger.log(tag: "NetworkClient", message: "request: \(request.url)\n \(String(data: data, encoding: .utf8) ??  "")")
        AF.request(req).validate().responseData { resp in
            Logger.log(tag: "NetworkClient", message: "statusCode: \(String(describing: resp.response?.statusCode))")
            let requestDecodeError: ResponseModel<Response> = ResponseModel(result: .failure(Self.decodeError))
            switch resp.result {
            case .success(let data):
                Logger.log(tag: "NetworkClient", message: "response: \(String(data: data, encoding: .utf8) ??  "")")
                do {
                    let natsResp = try self.decoder.decode(ResponseModel<Response>.self, from: data)
                    if case Result.failure(let networkError) = natsResp.result {
                        guard let error = networkError.error else {
                            completion(natsResp)
                            return
                        }
                        if error == ServerErrors.invalidToken.rawValue {
                            completion(natsResp)
                            authExpaired.onNext(())
                        } else if error == ServerErrors.tokenExpired.rawValue, self.tokenUpdateRetry < 2 {
                            self.tokenUpdateRetry += 1
                            self.refreshToken(completion: { result in
                                if result {
                                    self.request(request, auth: auth, timeOut: timeOut, completion: completion)
                                } else {
                                    completion(natsResp)
                                }
                            })
                        } else {
                            completion(natsResp)
                        }
                    } else {
                        completion(natsResp)
                    }
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
                Logger.log(tag: "NetworkClient", message: "failure: \(String(data: data, encoding: .utf8) ??  "")")
                do {
                    let natsResp = try self.decoder.decode(NetworkError.self, from: data)
                    guard let error = natsResp.error else {
                        completion(.init(result: .failure(natsResp)))
                        return
                    }
                    if error == ServerErrors.invalidToken.rawValue {
                        completion(.init(result: .failure(natsResp)))
                        authExpaired.onNext(())
                    } else if error == ServerErrors.tokenExpired.rawValue, self.tokenUpdateRetry < 2  {
                        self.tokenUpdateRetry += 1
                        self.refreshToken(completion: { result in
                            if result {
                                self.request(request, auth: auth, timeOut: timeOut, completion: completion)
                            } else {
                                completion(.init(result: .failure(natsResp)))
                            }
                        })
                    } else {
                        completion(.init(result: .failure(natsResp)))
                    }
                } catch {
                    Logger.log(tag: "NetworkClient", error: error)
                    completion(requestDecodeError)
                }
            }
        }
    }
    
    func refreshToken(completion: @escaping ((_ result: Bool) -> Void)) {
        guard let tkn = self.token else { return }
        self.request(.init(AppMethods.Auth.RefreshToken(.init())), auth: .auth) { response in
            switch response.result {
            case .success(let token):
                CoreAccount.updateToken(oldToken: tkn, newToken: token.token)
                self.token = token.token
                completion(true)
            case .failure(let error):
                Logger.log(error: error)
                completion(false)
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
    
    //public typealias ClosureCallback = ((Task) -> Void)
    //public typealias ImageCallback = ((Task?, KFCrossPlatformImage?) -> Void)
    
    func loadImage(into: ImageSet?, filePath: String, completion: ((_ result: UIImage?) -> Void)? = nil) {
        guard !filePath.isEmpty else { return }
        self.queue.async(flags: .barrier) {
            let hash = String(filePath.djb2hash)
            if let image = UIImage(contentsOfFile: self.getFileUrl(type: .image, name: hash).path) {
                into?.setImage(image: image)
                completion?(image)
            } else {
                let localUrl = self.getFileUrl(type: .image, name: hash)
                let url = "\(Constants.ApiUrl)/\(filePath)"
                AF.download(url, method: .get, headers: self.fileHeaders(auth: .auth), to:  { temporaryURL, response in
                    return (localUrl, [.removePreviousFile, .createIntermediateDirectories])
                }).downloadProgress { progress in
                    print("downloadProgress: \(progress.fractionCompleted)")
                }.response { response in
                    switch response.result {
                    case .success(_):
                        let image = UIImage(contentsOfFile: localUrl.path)
                        into?.setImage(image: image)
                        completion?(image)
                    case .failure(let error):
                        Logger.log(error: error)
                        debugPrint(error)
                        into?.loadFailed()
                        completion?(nil)
                    }
                }
            }
        }
    }
    
    func startUpload(file: URL, completion: @escaping ((_ result: String?) -> Void)) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(file, withName: "file", fileName: file.lastPathComponent, mimeType: "image/jpeg")
        }, to: "\(Constants.ApiUrl)/files/file", method: .post, headers: self.fileHeaders(auth: .auth))
        .uploadProgress { progress in
            print("uploadProgress: \(progress.fractionCompleted)")
        }.responseData { responseData in
            switch responseData.result {
            case .success(let data):
                do {
                    let dec = JSONDecoder()
                    let result = try dec.decode(UploadResult.self, from: data)
                    completion(result.message)
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
