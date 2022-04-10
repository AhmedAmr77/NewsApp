//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: BaseViewController {

    @IBOutlet weak private var newsTableView: UITableView!
    
    private var searchBar: UISearchBar!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private var disposeBag:DisposeBag!
    private var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        initializeSearchBar()
        instantiateRefreshControl()
        registerCell()
        
        instantiateRXItems()

        listenOnObservables()
    }
}

extension HomeViewController {
    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = Constants.newsTitle
    }
    
    private func initializeSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    private func instantiateRefreshControl(){
        newsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }
    
    private func registerCell() {
        let newsCell = UINib(nibName: Constants.newsCell, bundle: nil)
        newsTableView.register(newsCell, forCellReuseIdentifier: Constants.newsCell)
    }
    
    private func instantiateRXItems() {
        disposeBag = DisposeBag()
        viewModel = HomeViewModel()
        newsTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func listenOnObservables(){
        viewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else { print("HomeVC errorObservable"); return }
            self.showAlert(message)
        }).disposed(by: disposeBag)
        
        viewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else { print("HomeVC loadingObservable"); return }
            switch boolValue{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        viewModel.items.bind(to: newsTableView.rx.items) { (tableView, row, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCell, for: IndexPath(row: row, section: 0)) as? NewsTableViewCell
            cell?.config(with: item)
            return cell ?? UITableViewCell()
        }
        .disposed(by: disposeBag)
        
        newsTableView.rx.modelSelected(Article.self).subscribe(onNext: {[weak self] (newsItem) in
            guard let self = self else {return}
            let vc = NewsDetailsViewController()
            vc.article = newsItem
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.distinctUntilChanged().bind(to: viewModel.searchValue).disposed(by: disposeBag)
        
        newsTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.newsTableView.contentOffset.y
            let contentHeight = self.newsTableView.contentSize.height
            
            if offSetY > (contentHeight - self.newsTableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }.disposed(by: disposeBag)
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                let self = self else { return }
            if(isAvaliable){
                self.showLoading()
            }else{
                self.hideLoading()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
}

