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
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refresher: UIRefreshControl = UIRefreshControl()
    
    var viewModel = NewsSearchViewModel()
    
    private var loadingMoreNewsIndicator = UIActivityIndicatorView()
    
    private let disposeBag = DisposeBag()
    
    private var keywordsVar: Variable<String> = Variable("")
    var keywordsObservable: Observable<String> {
        return keywordsVar.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        tableView.backgroundColor = .clear
        
        title = "Search News"
        
        loadingMoreNewsIndicator.hidesWhenStopped = true
        
        refresher.addTarget(self, action: #selector(NewsSearchViewController.searchNews(keywords:)), for: .valueChanged)
        tableView.addSubview(refresher)
        
        setupTableView()
        
        bindViewModel(viewModel: viewModel)
        
        UISearchBar.appearance().tintColor = UIColor.red
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
        _ = keywordsObservable
            .throttle(1, scheduler: MainScheduler.instance)
            .filter({ (keywords) -> Bool in
                return !keywords.isEmpty
            })
            .subscribe(onNext: { [weak self] (keywords) in
            self?.searchNews(keywords: keywords)
        })
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
            self.searchMoreNews(keywords: keywordsVar.value)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension NewsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keywordsVar.value = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}
