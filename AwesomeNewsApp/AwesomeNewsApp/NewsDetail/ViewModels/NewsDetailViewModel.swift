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
    
    var dbManager: DatabaseManager!
    
    /// If the data is loaded from cache
    var loadedFromCache: Bool = false
    
    init() {
       dbManager = FirebaseManager()
    }
    
    func saveHtml(_ html: String?) {
        
        guard !loadedFromCache, let html = html, let url = url else {
            return
        }
        
        dbManager.saveHtml(html, forUrl: url)
    }
    
    func loadCachedHtml(completion: @escaping (String) -> Void) {
        if let url = url {
            dbManager.loadHtml(forUrl: url) { [weak self] (htmlString) in
                completion(htmlString)
                self?.loadedFromCache = true
            }
        }
    }
}
