//
//  NewsSource.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

/// Model class of news source
class NewsSource: Mappable {
    
    enum Keys: String {
        case id = "id"
        case name = "name"
    }
    
    var id: String?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
    }
}
