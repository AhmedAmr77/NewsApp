//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    var newsObservable: Observable<[Article]> { get }
    var errorObservable: Observable<(String)> { get }
    var loadingObservable: Observable<Bool> { get }
    var searchValue: BehaviorRelay<String> { get }
    
    func getData()
}

class HomeViewModel: HomeViewModelProtocol {
    var newsObservable: Observable<[Article]>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private var errorsubject = PublishSubject<String>()
    private var loadingsubject = PublishSubject<Bool>()
    private var newsSubject = PublishSubject<[Article]>()
    private lazy var searchValueObservable: Observable<String> = searchValue.asObservable()

    private var page = "1"
    private var limit = "15"
    private var country: String?
    private var categories: [String]?

    private var articles: [Article] = []
    private var searchedData: [Article]!

    private let newsAPI: NewsAPIContract!
    private let defaults = UserDefaults.standard
    private let disposeBag = DisposeBag()

    init() {
        newsAPI = NewsAPI.sharedInstance

        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        newsObservable = newsSubject.asObservable()

        searchedData = articles
        searchObserver()
        
        getUserSelections()
    }
    
    private func searchObserver() {
        searchValueObservable.subscribe(onNext: { [weak self] (value) in
            guard let self = self else { return }
            self.searchedData = self.articles.filter({ (article) -> Bool in
                article.title.lowercased().contains(value.lowercased())
            })
            if (value.isEmpty) {
                self.searchedData = self.articles
            }
            self.newsSubject.onNext(self.searchedData ?? [])
        }).disposed(by: disposeBag)
    }
    
    private func getUserSelections() {
        country = defaults.string(forKey: Constants.countryLocalKey) ?? ""
        categories = defaults.stringArray(forKey: Constants.categoryLocalKey) ?? []
    }
    
    func getData() {
        guard country != nil,
              categories != nil else { print("HomeVM getData failed"); return}
        loadingsubject.onNext(true)
        categories!.forEach { (category) in
            newsAPI.getNews(country: country!, category: category, page: page, limit: limit) { [weak self] (result) in
                guard let self = self else { print("HomeVM getNews failed"); return }
                self.loadingsubject.onNext(false)
                switch result{
                case .success(let response):
                    self.articles = response?.articles ?? []
                    self.newsSubject.onNext(response?.articles ?? [])
                case .failure(let error):
                    self.errorsubject.onNext(error.localizedDescription)
                }
            }
        }
    }
}
