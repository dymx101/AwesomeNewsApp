//
//  FirebaseManager.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    let newsListRef = Database.database().reference(withPath: "newslist")
    
    func saveNewsList(newslist: NewsList) {
        newsListRef.child("status").setValue(newslist.status)
        newsListRef.child("totalResults").setValue(newslist.totalResults)
        if let articles = newslist.articles {
            let articlesRef = newsListRef.child("articles")
            for article in articles {
                let articleRef = articlesRef.childByAutoId()
                
                articleRef.child("author").setValue(article.author)
                articleRef.child("title").setValue(article.title)
                articleRef.child("desc").setValue(article.desc)
                articleRef.child("url").setValue(article.url)
                articleRef.child("urlToImage").setValue(article.urlToImage)
                articleRef.child("publishedAt").setValue(article.publishedAt)
                
                if let source = article.source {
                    articleRef.child("source").child("id").setValue(source.id)
                    articleRef.child("source").child("name").setValue(source.name)
                }
                
            }
        }
    }
    
    func readNewsList() -> NewsList? {
        
        newsListRef.observe(.value) { (snapshot) in
            if snapshot.exists() {
                
            } else {
                
            }
        }
        
        return nil
    }
}
