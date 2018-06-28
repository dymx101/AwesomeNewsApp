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

/// View controller for news list display
class NewsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let refresher: UIRefreshControl = UIRefreshControl()
    
    var viewModel = NewsListViewModel()
    
    private var loadingMoreNewsIndicator = UIActivityIndicatorView()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        tableView.backgroundColor = .clear
        
        loadingMoreNewsIndicator.hidesWhenStopped = true
        
        refresher.addTarget(self, action: #selector(NewsListViewController.reloadNews), for: .valueChanged)
        tableView.addSubview(refresher)
        
        setupTableView()
    
        bindViewModel(viewModel: viewModel)
        
        reloadNews()
        refresher.beginRefreshing()
    }
    
    func setupTableView() {
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: NewsListItemCell.theID, bundle: nil), forCellReuseIdentifier: NewsListItemCell.theID)
        
        _ = tableView.rx.itemSelected.subscribe(onNext:{ [weak self] indexPath in
            guard let articles = self?.viewModel.newsList?.articles, indexPath.row < articles.count else {
                return
            }
            
            self?.tableView.deselectRow(at: indexPath, animated: true)
            
            let viewModel = NewsDetailViewModel()
            viewModel.url = articles[indexPath.row].url
            self?.performSegue(withIdentifier: "showDetail", sender: viewModel)
            
        }).disposed(by: disposeBag)
        
        let footerView = UIView()
        footerView.addSubview(loadingMoreNewsIndicator)
        loadingMoreNewsIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(30)
        }
        tableView.tableFooterView = footerView
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 35, 0)
    }
    
    func bindViewModel(viewModel: NewsListViewModel) {
        viewModel.newsItemViewModelsObservable.bind(to: tableView.rx.items(cellIdentifier: NewsListItemCell.theID, cellType: NewsListItemCell.self)) { (_, model: NewsItemViewModel, cell: NewsListItemCell) in
                                                        cell.config(withViewModel: model)
            }.disposed(by: disposeBag)
    }
    
    @objc fileprivate func reloadNews() {
        viewModel.reloadNews { [weak self] _ in
            self?.refresher.endRefreshing()
        }
    }
    
    @objc fileprivate func loadMoreNews() {
        viewModel.loadMoreNews { [weak self] _ in
            self?.loadingMoreNewsIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewModel = sender as? NewsDetailViewModel
        let destinationController = segue.destination as? NewsDetailViewController
        
        destinationController?.viewModel = viewModel
    }
}

extension NewsListViewController: UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height
            && viewModel.hasMoreNews()
            && !viewModel.isRequesting(){
            loadingMoreNewsIndicator.startAnimating()
            self.loadMoreNews()
        }
    }
}

