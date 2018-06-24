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
//        case apiKey = "28581b5630064b359aac9806bd9ed0b5"
        case apiKey = "4a9eadd464ee4c67809a4a50864b1c9e"
        case baseURL = "https://newsapi.org"
    }
    
    static let apiKey = Constants.apiKey.rawValue
    
    func getURL(endpoint: Endpoints) -> URL? {
        var url = URL(string: Constants.baseURL.rawValue)
        url?.appendPathComponent(endpoint.rawValue)
        return url
    }
    
    func getHeadlinesURL(parameters: HeadlinesRequestParameters) -> URL? {
        guard var urlString = getURL(endpoint: .headlines)?.absoluteString else {
            return nil
        }

        urlString = urlString + "?" + parameters.paramString()
        
        return URL(string: urlString)
    }
    
    func loadHeaderlines(params: HeadlinesRequestParameters, completion:@escaping (NewsList?)->Void) {
        
        guard let url = getHeadlinesURL(parameters: params) else {return}
        
        Alamofire.request(url).responseObject { (respObject: DataResponse<NewsList>) in
            completion(respObject.result.value)
        }
    }
}
