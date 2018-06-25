//
//  NewsListItemCell.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

class NewsListItemCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private var viewModel: NewsItemViewModel?
    
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(withViewModel viewModel:NewsItemViewModel) {
        self.viewModel = viewModel
        
        _ = viewModel.titleObservable.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        _ = viewModel.descObservable.bind(to: descLabel.rx.text).disposed(by: disposeBag)
        
        _ = viewModel.urlToImageObservable.subscribe(onNext:{ [weak self] (urlToImage) in
            self?.coverImageView.image = nil
            if let url = URL(string: urlToImage) {
                self?.coverImageView.af_setImage(withURL: url)
            }
        }).disposed(by: disposeBag)
    }
    
    static var theID: String {
        return "NewsListItemCell"
    }
}
