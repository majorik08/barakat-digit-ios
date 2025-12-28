//
//  StoriesImageView.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation
import UIKit

public enum IGResult<V, E> {
    case success(V)
    case failure(E)
}

private struct ActivityKeys {
    static var isEnabled: UInt8 = 0
    static var style: UInt8 = 0
    static var view: UInt8 = 0
}

public typealias ImageResponse = (IGResult<UIImage, Error>) -> Void

protocol IGImageRequestable {
    func setImage(urlString: String, placeHolderImage: UIImage?, completionBlock: ImageResponse?)
}

fileprivate let ONE_HUNDRED_MEGABYTES = 1024 * 1024 * 100

class IGCache: NSCache<AnyObject, AnyObject> {
    static let shared = IGCache()
    private override init() {
        super.init()
        self.setMaximumLimit()
    }
}

extension IGCache {
    func setMaximumLimit(size: Int = ONE_HUNDRED_MEGABYTES) {
        totalCostLimit = size
    }
}

public enum IGError: Error, CustomStringConvertible {

    case invalidImageURL
    case downloadError

    public var description: String {
        switch self {
        case .invalidImageURL: return "Invalid Image URL"
        case .downloadError: return "Unable to download image"
        }
    }
}

//class IGURLSession: URLSession {
//    static let `default` = IGURLSession()
//    private(set) var dataTasks: [URLSessionDataTask] = []
//}
//extension IGURLSession {
//    func cancelAllPendingTasks() {
//        dataTasks.forEach({
//            if $0.state != .completed {
//                $0.cancel()
//            }
//        })
//    }
//
//    func downloadImage(using urlString: String, completionBlock: @escaping ImageResponse) {
//        guard let url = URL(string: urlString) else {
//            return completionBlock(.failure(IGError.invalidImageURL))
//        }
//        dataTasks.append(IGURLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if let result = data, error == nil, let imageToCache = UIImage(data: result) {
//                IGCache.shared.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
//                completionBlock(.success(imageToCache))
//            } else {
//                return completionBlock(.failure(error ?? IGError.downloadError))
//            }
//        }))
//        dataTasks.last?.resume()
//    }
//}

enum ImageStyle: Int {
    case squared,rounded
}

typealias SetImageRequester = (IGResult<Bool,Error>) -> Void

extension UIImageView: IGImageRequestable {
    func setImage(url: String, completion: SetImageRequester? = nil) {
        image = nil
        //The following stmts are in SEQUENCE. before changing the order think twice :P
        isActivityEnabled = true
        layer.masksToBounds = false
        if #available(iOS 13.0, *) {
            activityStyle = .medium
        } else {
            activityStyle = .gray
        }
        clipsToBounds = true
        setImage(urlString: url) { (response) in
            if let completion = completion {
                switch response {
                case .success(_):
                    completion(IGResult.success(true))
                case .failure(let error):
                    completion(IGResult.failure(error))
                }
            }
        }
    }
}


extension IGImageRequestable where Self: UIImageView {

    func setImage(urlString: String, placeHolderImage: UIImage? = nil, completionBlock: ImageResponse?) {

        self.image = (placeHolderImage != nil) ? placeHolderImage! : nil
        self.showActivityIndicator()

        if let cachedImage = IGCache.shared.object(forKey: urlString as AnyObject) as? UIImage {
            self.hideActivityIndicator()
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            guard let completion = completionBlock else { return }
            return completion(.success(cachedImage))
        } else {
            APIManager.instance.loadImage(into: self, filePath: urlString) { [weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.hideActivityIndicator()
                if let image = result {
                    IGCache.shared.setObject(image, forKey: urlString as AnyObject)
                    guard let completion = completionBlock else { return }
                    return completion(.success(image))
                } else {
                    guard let completion = completionBlock else { return }
                    return completion(.failure(APIManager.downloadError))
                }
            }
//            IGURLSession.default.downloadImage(using: urlString) { [weak self] (response) in
//                guard let strongSelf = self else { return }
//                strongSelf.hideActivityIndicator()
//                switch response {
//                case .success(let image):
//                    IGCache.shared.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
//                    DispatchQueue.main.async {
//                        strongSelf.image = image
//                    }
//                    guard let completion = completionBlock else { return }
//                    return completion(.success(image))
//                case .failure(let error):
//                    guard let completion = completionBlock else { return }
//                    return completion(.failure(error))
//                }
//            }
        }
    }
}

extension UIImageView {

    //Responsiblity: to holds the List of Activity Indicator for ImageView
    //DataSource: UI-Level
    struct ActivityIndicator {
        static var isEnabled = false
        static var style = _style
        static var view = _view
        
        static var _style: UIActivityIndicatorView.Style {
            if #available(iOS 13.0, *) {
                return .large
            }else {
                return .whiteLarge
            }
        }
        
        static var _view: UIActivityIndicatorView {
            if #available(iOS 13.0, *) {
                return UIActivityIndicatorView(style: .large)
            }else {
                return UIActivityIndicatorView(style: .whiteLarge)
            }
        }
    }
    
    //MARK: Public Vars
    public var isActivityEnabled: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &ActivityKeys.isEnabled) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ActivityKeys.isEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var activityStyle: UIActivityIndicatorView.Style {
        get{
            guard let value = objc_getAssociatedObject(self, &ActivityKeys.style) as? UIActivityIndicatorView.Style else {
                if #available(iOS 13.0, *) {
                    return .large
                }else {
                    return .whiteLarge
                }
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ActivityKeys.style, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var activityIndicator: UIActivityIndicatorView {
        get {
            guard let value = objc_getAssociatedObject(self, &ActivityKeys.view) as? UIActivityIndicatorView else {
                if #available(iOS 13.0, *) {
                    return UIActivityIndicatorView(style: .large)
                }else {
                    return UIActivityIndicatorView(style: .whiteLarge)
                }
            }
            return value
        }
        set(newValue) {
            let activityView = newValue
            activityView.hidesWhenStopped = true
            objc_setAssociatedObject(self, &ActivityKeys.view, activityView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK: - Private methods
    func showActivityIndicator() {
        if isActivityEnabled {
            var isActivityIndicatorFound = false
            DispatchQueue.main.async {
                self.backgroundColor = .black
                self.activityIndicator = UIActivityIndicatorView(style: self.activityStyle)
                self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                self.activityIndicator.color = Theme.current.tintColor
                if self.subviews.isEmpty {
                    isActivityIndicatorFound = false
                    self.addSubview(self.activityIndicator)
                    
                } else {
                    for view in self.subviews {
                        if !view.isKind(of: UIActivityIndicatorView.self) {
                            isActivityIndicatorFound = false
                            self.addSubview(self.activityIndicator)
                            break
                        } else {
                            isActivityIndicatorFound = true
                        }
                    }
                }
                if !isActivityIndicatorFound {
                    NSLayoutConstraint.activate([
                        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                        ])
                }
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    func hideActivityIndicator() {
        if isActivityEnabled {
            DispatchQueue.main.async {
                self.backgroundColor = UIColor.black
                self.subviews.forEach({ (view) in
                    if let av = view as? UIActivityIndicatorView {
                        av.stopAnimating()
                    }
                })
            }
        }
    }
}
