//
//  FirebaseManager.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Firebase

protocol DatabaseManager {
    func saveHtml(_ html: String, forUrl url:String)
    func loadHtml(forUrl url: String, completion: @escaping (String) -> Void)
    func saveNewsList(newslist: NewsList)
    func loadNewsList(completion:@escaping (NewsList?)->Void)
}

class FirebaseManager: DatabaseManager {
    
    enum Tables: String {
        case newsList = "newsList"
        case newsHtml = "newsHtml"
    }
    
    let newsListRef = Database.database().reference(withPath: Tables.newsList.rawValue)
    let newsHtmlRef = Database.database().reference(withPath: Tables.newsHtml.rawValue)
    
    // MARK: Save&Load html for news detail
    func saveHtml(_ html: String, forUrl url:String) {
        newsListRef.child(url.toMD5()).removeValue()
        newsHtmlRef.child(url.toMD5()).setValue(html)
    }
    
    func loadHtml(forUrl url: String, completion: @escaping (String) -> Void) {
        newsHtmlRef.child(url.toMD5()).observe(.value) { (snapshot) in
            let htmlString = snapshot.value as? String
            completion(htmlString ?? "")
        }
    }
    
    // MARK: Save&Load news list
    func saveNewsList(newslist: NewsList) {
        newsListRef.removeValue()
        
        newsListRef.child(NewsList.Keys.status.rawValue).setValue(newslist.status)
        newsListRef.child(NewsList.Keys.totalResults.rawValue).setValue(newslist.totalResults)
        
        if let articles = newslist.articles {
            let articlesRef = newsListRef.child(NewsList.Keys.articles.rawValue)
            for article in articles {
                let articleRef = articlesRef.childByAutoId()
                
                articleRef.child(NewsItem.Keys.author.rawValue).setValue(article.author)
                articleRef.child(NewsItem.Keys.title.rawValue).setValue(article.title)
                articleRef.child(NewsItem.Keys.desc.rawValue).setValue(article.desc)
                articleRef.child(NewsItem.Keys.url.rawValue).setValue(article.url)
                articleRef.child(NewsItem.Keys.urlToImage.rawValue).setValue(article.urlToImage)
                articleRef.child(NewsItem.Keys.publishedAt.rawValue).setValue(article.publishedAt)
                
                if let source = article.source {
                    articleRef.child(NewsItem.Keys.source.rawValue)
                        .child(NewsSource.Keys.id.rawValue).setValue(source.id)
                    articleRef.child(NewsItem.Keys.source.rawValue)
                        .child(NewsSource.Keys.name.rawValue).setValue(source.name)
                }
                
            }
        }
    }
    
    func loadNewsList(completion:@escaping (NewsList?)->Void) {
        
        newsListRef.observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                
                guard let newsList = NewsList(JSON: [:]) else {
                    completion(nil)
                    return
                }
                
                newsList.status = snapshot.childSnapshot(forPath: NewsList.Keys.status.rawValue).value as? String
                newsList.totalResults = snapshot.childSnapshot(forPath: NewsList.Keys.totalResults.rawValue).value as? Int
                
                let snapshotArticles = snapshot.childSnapshot(forPath: NewsList.Keys.articles.rawValue)
                
                guard snapshotArticles.exists() else {
                    completion(newsList)
                    return
                }
                
                newsList.articles = [NewsItem]()
                
                for item in snapshotArticles.children {
                    let snapshotItem = item as! DataSnapshot // item is a DataSpanshot for sure!
                    if let article = NewsItem(JSON: [:]) {
                        article.author = snapshotItem.childSnapshot(forPath: NewsItem.Keys.author.rawValue).value as? String
                        article.title = snapshotItem.childSnapshot(forPath: NewsItem.Keys.title.rawValue).value as? String
                        article.desc = snapshotItem.childSnapshot(forPath: NewsItem.Keys.desc.rawValue).value as? String
                        article.url = snapshotItem.childSnapshot(forPath: NewsItem.Keys.url.rawValue).value as? String
                        article.urlToImage = snapshotItem.childSnapshot(forPath: NewsItem.Keys.urlToImage.rawValue).value as? String
                        article.publishedAt = snapshotItem.childSnapshot(forPath: NewsItem.Keys.publishedAt.rawValue).value as? String
                        
                        let snapshotSource = snapshotItem.childSnapshot(forPath: NewsItem.Keys.source.rawValue)
                        if snapshotSource.exists() {
                            if let newsSource = NewsSource(JSON: [:]) {
                                newsSource.id = snapshotSource.childSnapshot(forPath: NewsSource.Keys.id.rawValue).value as? String
                                newsSource.name = snapshotSource.childSnapshot(forPath: NewsSource.Keys.name.rawValue).value as? String
                                
                                article.source = newsSource
                            }
                        }
                        
                        newsList.articles?.append(article)
                    }
                }
                
                completion(newsList)
            }
        }
    }
}
