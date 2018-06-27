//
//  NewsDetailViewController.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import SnapKit

class NewsDetailViewController: UIViewController {
    
    struct Constants {
        static let kvoKeyEstimatedProgress = "estimatedProgress"
        static let kvoKeyLoading = "loading"
        // A magic number to hide loading, because WKWebView sometimes never finish loaing and reach 1.0
        static let progressToHideLoading = 0.89
    }

    private var webView: WKWebView!
    private var progressView: UIView!
    private var proressWidthConstraint: NSLayoutConstraint?
    
    var viewModel: NewsDetailViewModel?
    
    var firebaseManager: FirebaseManager!
    var loadedFromCache: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Detail"
        
        firebaseManager = FirebaseManager()
        
        installWebView()
        installProgressView()
        
        loadNews()
    }
    
    func loadNews() {
        guard let url = URL(string: viewModel?.url ?? "") else {return}
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func installWebView() {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.loading), options: [.new, .old], context: nil)
    }
    
    func installProgressView() {
        progressView = UIView()
        progressView.isHidden = true
        progressView.backgroundColor = .orange
        view.addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        proressWidthConstraint = progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0)
        proressWidthConstraint?.isActive = true
    }
    
    func hideProgressView() {
        proressWidthConstraint?.isActive = false
        proressWidthConstraint = progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0)
        proressWidthConstraint?.isActive = true
        progressView.isHidden = true
    }
    
    // MARK: KVO, make sure the indicatorView stop animating
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.kvoKeyEstimatedProgress {
            if let value = change?[.newKey] as? Double {
                proressWidthConstraint?.isActive = false
                proressWidthConstraint = progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat(value))
                proressWidthConstraint?.isActive = true
                
                if (value > Constants.progressToHideLoading) {
                    hideProgressView()
                }
            }
        } else if keyPath == Constants.kvoKeyLoading {
            guard let newValue = change?[.newKey] as? Int, let oldValue = change?[.oldKey] as? Int else {
                return
            }
            if (newValue == 0 && oldValue == 1) {
                hideProgressView()
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: Constants.kvoKeyEstimatedProgress)
        webView.removeObserver(self, forKeyPath: Constants.kvoKeyLoading)
    }
    
    func saveHtml() {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: {
            [weak self] (html: Any?, error: Error?) in
            if let html = html as? String, let url = self?.viewModel?.url {
                self?.firebaseManager.saveHtml(html, forUrl: url)
            }
        })
    }
}

extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        if let url = viewModel?.url {
            firebaseManager.loadHtml(forUrl: url) { [weak self] (htmlString) in
                webView.loadHTMLString(htmlString, baseURL: nil)
                self?.loadedFromCache = true
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
        if !loadedFromCache {
            saveHtml()
        }
    }
}
