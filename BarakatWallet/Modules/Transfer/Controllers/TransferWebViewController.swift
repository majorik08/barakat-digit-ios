//
//  TransferWebController.swift
//  BarakatWallet
//
//  Created by km1tj on 16/02/24.
//

import Foundation
import UIKit
import WebKit
import Foundation

protocol WalletWebViewControllerDelegate: AnyObject {
    func getUpdatedIntent(result: Bool)
}

class WalletWebViewController: BaseViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    //var allHTTPHeaderFields: [String : String]?
    var url: URL
    weak var delegate: WalletWebViewControllerDelegate?
    let activityNode = UIActivityIndicatorView(style: .gray)
    
    init(url: URL, delegate: WalletWebViewControllerDelegate?) {
        self.url = url
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("WalletWebViewController deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.webView = WKWebView(frame: .zero)
        self.webView.backgroundColor = Theme.current.plainTableBackColor
        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        //self.view = self.webView
        self.view.addSubview(self.activityNode)
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        self.activityNode.tintColor = Theme.current.tintColor
        self.activityNode.hidesWhenStopped = true
        self.activityNode.center = self.view.center
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadUrl))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "DONE".localized, style: .done, target: self, action: #selector(closeView))
        self.loadUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func closeView() {
        self.navigationController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    @objc func loadUrl() {
        let req = URLRequest(url: self.url)
        //req.allHTTPHeaderFields = self.allHTTPHeaderFields
        self.webView.isHidden = true
        self.activityNode.startAnimating()
        self.webView.load(req)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityNode.stopAnimating()
        self.webView.isHidden = false
        debugPrint(error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityNode.stopAnimating()
        self.webView.isHidden = false
        self.navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("didReceive challenge")
//    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webView:decidePolicyForNavigationAction:\(navigationAction)")
        if let url = navigationAction.request.url, url.absoluteString == "https://barakatmoliya.tj/transfer/result" {
            self.delegate?.getUpdatedIntent(result: true)
            self.closeView()
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
