//
//  ViewController.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    
    var viewModel = NewsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        _ = viewModel.newsItemViewModelsObservable.subscribe(onNext: { (newsItemViewModels) in
            print(newsItemViewModels)
        })
            
        viewModel.reloadNews { (newsList) in
            
        }
    }
}

