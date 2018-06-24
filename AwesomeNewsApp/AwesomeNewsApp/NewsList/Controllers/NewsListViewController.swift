//
//  ViewController.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/23.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = NewsListViewModel()
    
    /// A dispose bag to be sure that all element added to the bag is deallocated properly.
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        viewModel.reloadNews { _ in }
        
        bindViewModel(viewModel: viewModel)
    }
    
    func bindViewModel(viewModel: NewsListViewModel) {
        viewModel.newsItemViewModelsObservable.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (_, model: NewsItemViewModel, cell: UITableViewCell) in
                                                        cell.textLabel?.text = model.title
            }.disposed(by: disposeBag)
    }
}

