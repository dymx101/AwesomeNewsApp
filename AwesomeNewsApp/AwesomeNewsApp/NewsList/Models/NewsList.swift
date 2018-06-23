//
//  NewsList.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsList: Mappable {
    
    var articles: [NewsItem]?
    var status: String?
    var code: String?
    var message: String?
    var totalResults: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        articles <- map["articles"]
        status <- map["status"]
        code <- map["code"]
        message <- map["message"]
        totalResults <- map["totalResults"]
    }
}
