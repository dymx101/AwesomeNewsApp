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
    
    private var viewModel: NewsItemViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(withViewModel viewModel:NewsItemViewModel) {
        self.viewModel = viewModel
        
        _ = viewModel.titleObservable.bind(to: titleLabel.rx.text)
        _ = viewModel.descObservable.bind(to: descLabel.rx.text)
    }
    
    static var theID: String {
        return "NewsListItemCell"
    }
}
