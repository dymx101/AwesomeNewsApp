//
//  NewsListItemCell.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class NewsListItemCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var theID: String {
        return "NewsListItemCell"
    }
}
