//
//  NewsDetailViewModel.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/25.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class NewsDetailViewModel {
    
    var url: String?
    
    var firebaseManager: FirebaseManager!
    
    /// If the data is loaded from cache
    var loadedFromCache: Bool = false
    
    init() {
       firebaseManager = FirebaseManager()
    }
    
    func saveHtml(_ html: String?) {
        
        guard !loadedFromCache, let html = html, let url = url else {
            return
        }
        
        firebaseManager.saveHtml(html, forUrl: url)
    }
    
    func loadCachedHtml(completion: @escaping (String) -> Void) {
        if let url = url {
            firebaseManager.loadHtml(forUrl: url) { [weak self] (htmlString) in
                completion(htmlString)
                self?.loadedFromCache = true
            }
        }
    }
}
