//
//  NewsClient.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class NewsClient {
    
    enum Endpoints: String {
        case headlines = "v2/top-headlines"
        case everything = "v2/everything"
        case sources = "v2/sources"
    }
    
    enum Constants: String {
        case apiKey = "28581b5630064b359aac9806bd9ed0b5"
        case baseURL = "https://newsapi.org"
    }
    
    let apiKey = Constants.apiKey
    
    func getURL(endpoint: Endpoints) -> URL? {
        var url = URL(string: Constants.baseURL.rawValue)
        url?.appendPathComponent(endpoint.rawValue)
        return url
    }
    
    func loadHeaderlines(endpoint: Endpoints, completion:@escaping (NewsList?)->Void) {
        
        guard let url = getURL(endpoint: .headlines) else {return}
        
        Alamofire.request(url).responseObject { (respObject: DataResponse<NewsList>) in
            completion(respObject.result.value)
        }
    }
}
