//
//  NewsSearchViewController.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refresher: UIRefreshControl = UIRefreshControl()
    
    var viewModel = NewsSearchViewModel()
    
    private var loadingMoreNewsIndicator = UIActivityIndicatorView()
    
    private let disposeBag = DisposeBag()
    
    private let keywords = "bitcoin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        tableView.backgroundColor = .clear
        
        loadingMoreNewsIndicator.hidesWhenStopped = true
        
        refresher.addTarget(self, action: #selector(NewsSearchViewController.searchNews(keywords:)), for: .valueChanged)
        tableView.addSubview(refresher)
        
        setupTableView()
        
        bindViewModel(viewModel: viewModel)
        
        searchNews(keywords: keywords)
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
    
    func bindViewModel(viewModel: NewsSearchViewModel) {
        viewModel.newsItemViewModelsObservable.bind(to: tableView.rx.items(cellIdentifier: NewsListItemCell.theID, cellType: NewsListItemCell.self)) { (_, model: NewsItemViewModel, cell: NewsListItemCell) in
            cell.config(withViewModel: model)
            }.disposed(by: disposeBag)
    }
    
    @objc fileprivate func searchNews(keywords: String) {
        viewModel.searchNews(keywords: keywords) { [weak self] _ in
            self?.refresher.endRefreshing()
        }
    }
    
    @objc fileprivate func searchMoreNews(keywords: String) {
        viewModel.searchMoreNews(keywords: keywords) { [weak self] _ in
            self?.loadingMoreNewsIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewModel = sender as? NewsDetailViewModel
        let destinationController = segue.destination as? NewsDetailViewController
        
        destinationController?.viewModel = viewModel
    }
}

extension NewsSearchViewController: UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            loadingMoreNewsIndicator.startAnimating()
            self.searchMoreNews(keywords: keywords)
        }
    }
}
