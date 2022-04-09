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
    
    private var disposeBag:DisposeBag!
    private var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        registerCell()
        
        instantiateRXItems()

        listenOnObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getData()
    }
}

extension HomeViewController {
    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = Constants.newsTitle
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
        
        viewModel.newsObservable.bind(to: newsTableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCell, for: IndexPath(row: row, section: 0)) as! NewsTableViewCell
            cell.config(with: item)
            return cell
        }
        .disposed(by: disposeBag)
        
        newsTableView.rx.modelSelected(Article.self).subscribe(onNext: {[weak self] (newsItem) in
            guard let self = self else {return}
            print("Navigate to Details")
        }).disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
}

