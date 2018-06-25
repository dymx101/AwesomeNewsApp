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
    let refresher: UIRefreshControl = UIRefreshControl()
    
    var viewModel = NewsListViewModel()
    
    /// A dispose bag to be sure that all element added to the bag is deallocated properly.
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        tableView.backgroundColor = .clear
        
        title = "Awesome News"
        
        refresher.addTarget(self, action: #selector(NewsListViewController.reloadNews), for: .valueChanged)
        
        tableView.delegate = self
        tableView.addSubview(refresher)
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: NewsListItemCell.theID, bundle: nil), forCellReuseIdentifier: NewsListItemCell.theID)
    
        bindViewModel(viewModel: viewModel)
        
        reloadNews()
        refresher.beginRefreshing()
    }
    
    func bindViewModel(viewModel: NewsListViewModel) {
        viewModel.newsItemViewModelsObservable.bind(to: tableView.rx.items(cellIdentifier: NewsListItemCell.theID, cellType: NewsListItemCell.self)) { (_, model: NewsItemViewModel, cell: NewsListItemCell) in
                                                        cell.config(withViewModel: model)
            }.disposed(by: disposeBag)
    }
    
    @objc fileprivate func reloadNews() {
        viewModel.reloadNews {
            [weak self] _ in self?.refresher.endRefreshing()
        }
    }
    
    @objc fileprivate func loadMoreNews() {
        viewModel.loadMoreNews {
            [weak self] _ in self?.refresher.endRefreshing()
        }
    }
}

extension NewsListViewController: UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            self.loadMoreNews()
        }
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == self.viewModel.newsCount() - 1 {
//            self.loadMoreNews()
//        }
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//    }
}

