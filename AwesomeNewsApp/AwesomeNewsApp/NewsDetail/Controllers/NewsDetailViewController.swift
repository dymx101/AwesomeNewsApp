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
import NVActivityIndicatorView

class NewsDetailViewController: UIViewController {
    
    struct Constants {
        static let kvoKeyEstimatedProgress = "estimatedProgress"
        static let kvoKeyLoading = "loading"
        // A magic number to hide loading, because WKWebView sometimes never finish loaing and reach 1.0
        static let progressToHideLoading = 0.89
    }

    var webView: WKWebView!
    var indicatorView: NVActivityIndicatorView!
    
    var viewModel: NewsDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News Detail"
        
        installWebView()
        installIndicatorView()
        
        loadNews()
    }
    
    func loadNews() {
        guard let url = URL(string: viewModel?.url ?? "") else {return}
        
        let request = URLRequest(url: url)
        webView.load(request)
        indicatorView.startAnimating()
    }
    
    func installWebView() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.loading), options: [.new, .old], context: nil)
    }
    
    func installIndicatorView() {
        indicatorView = NVActivityIndicatorView(frame: CGRect.zero, type: .ballSpinFadeLoader, color: UIColor.black)
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
    }
    
    // MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.kvoKeyEstimatedProgress {
            if let value = change?[.newKey] as? Double, value > Constants.progressToHideLoading {
                indicatorView.stopAnimating()
            }
        } else if keyPath == Constants.kvoKeyLoading {
            guard let newValue = change?[.newKey] as? Int, let oldValue = change?[.oldKey] as? Int else {
                return
            }
            if (newValue == 0 && oldValue == 1) {
                indicatorView.stopAnimating()
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: Constants.kvoKeyEstimatedProgress)
        webView.removeObserver(self, forKeyPath: Constants.kvoKeyLoading)
    }
}
