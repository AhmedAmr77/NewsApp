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
    var refreshControlAction: PublishSubject<Void> { get }
    var fetchMoreDatas: PublishSubject<Void> { get }
    var refreshControlCompelted: PublishSubject<Void> { get }
    var isLoadingSpinnerAvaliable: PublishSubject<Bool> { get }
}

class HomeViewModel: HomeViewModelProtocol {
    var newsObservable: Observable<[Article]>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var searchValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    var items: BehaviorRelay<[Article]>

    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()
    let refreshControlCompelted = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    
    private var errorsubject = PublishSubject<String>()
    private var loadingsubject = PublishSubject<Bool>()
    private var newsSubject = PublishSubject<[Article]>()
    private lazy var searchValueObservable: Observable<String> = searchValue.asObservable()

    private var maxValue: Int?
    private var pageCounter = 1
    private var limit = 15
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    private var country: String?
    private var categories: [String]?

    private var articles: [Article] = []
    private var searchedData: [Article]!
    
    private let userDefaults: LocalUserDefaults!
    private let newsCache: NewsCache!
    private let newsAPI: NewsAPIContract!
    private let disposeBag = DisposeBag()

    init() {
        userDefaults = LocalUserDefaults.sharedInstance
        newsCache = NewsCache.sharedInstance
        newsAPI = NewsAPI.sharedInstance
        items = BehaviorRelay<[Article]>(value: [])
        
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        newsObservable = newsSubject.asObservable()

        searchedData = articles

        bind()

        getUserSelections()
    }
    
    private func bind() {
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
        
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData(page: self.pageCounter,
                                isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    private func refreshControlTriggered() {
        newsAPI.cancelAllRequests()
//        isPaginationRequestStillResume = false
        pageCounter = 1
//        items.accept([])
        fetchData(page: pageCounter,
                       isRefreshControl: true)
    }
    
    private func fetchData(page: Int, isRefreshControl: Bool) {
        self.loadingsubject.onNext(true)
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter > (maxValue ?? 2)  {
            isPaginationRequestStillResume = false
            return
        }
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter  == 1 || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        newsAPI.getNews(country: country!, category: categories![0], page: String(pageCounter), limit: String(limit)) { [weak self] (result) in
            guard let self = self else{
                print("HVM getNews failed")
                return
            }
            switch result{
            case .success(let response):
                self.maxValue = (Int((response?.totalResults ?? 0) / self.limit) + 1)
                print("\t\t\t\t\t\t\t", response?.totalResults)
                self.loadingsubject.onNext(false)
                if let articles = response?.articles,
                   !articles.isEmpty {
                    self.handleData(data: articles)
                }
            case .failure(let error):
                self.newsCache.getNews(completion: { (articlesArray) in
                    if articlesArray.isEmpty {
                        self.items.accept(articlesArray)
                        self.newsSubject.onNext(articlesArray)
                        self.errorsubject.onNext(error.localizedDescription)
                        return
                    } else {
                        self.loadingsubject.onNext(false)
                        self.errorsubject.onNext(error.localizedDescription)
                    }
                })
            }
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.isRefreshRequstStillResume = false
            self.refreshControlCompelted.onNext(())
        }
    }
    
    private func handleData(data: [Article]) {
        print("in handle data")
        newsCache.deleteAll()
        var newData = data
        if pageCounter != 1 {
            print("HD pc !=1")
            let oldDatas = items.value
            newData = oldDatas + newData
        }
        saveArticlesToLocal(articles)
        self.items.accept(newData)
        self.newsSubject.onNext(newData)
        pageCounter += 1
    }

    private func getUserSelections() {
        country = userDefaults.getCountry() ?? ""
        categories = userDefaults.getCategories() ?? []
    }
    
//    func getData() {
//        guard country != nil,
//              categories != nil else { print("HomeVM getData failed"); return}
//        var isOldLocalDeleted = false
//        loadingsubject.onNext(true)
//        if userDefaults.isLastNewsRequestPassed() {
//            categories!.forEach { (category) in
//                newsAPI.getNews(country: country!, category: category, page: pageCounter, limit: limit) { [weak self] (result) in
//                    guard let self = self else { print("HomeVM getNews failed"); return }
//                    self.loadingsubject.onNext(false)
//                    switch result{
//                    case .success(let response):
//                        let fetchedAtricle = response?.articles ?? []
//                        self.userDefaults.setLastNewsRequest()
//                        self.articles = fetchedAtricle
//                        self.newsSubject.onNext(fetchedAtricle)
//                        if !isOldLocalDeleted {
//                            self.newsCache.deleteAll()
//                            isOldLocalDeleted = true
//                        }
//                        self.saveArticlesToLocal(fetchedAtricle)
//                    case .failure(let error):
//                        self.errorsubject.onNext(error.localizedDescription)
//                    }
//                }
//            }
//        } else {
//            self.loadingsubject.onNext(false)
//            newsCache.getNews { [weak self] (articles) in
//                guard let self = self else { print("HomeVM getCachedNews failed"); return }
//                self.articles = articles
//                self.newsSubject.onNext(articles)
//            }
//        }
//    }
    
    private func saveArticlesToLocal(_ atricles: [Article]) {
        articles.forEach { (article) in
            newsCache.save(article: article)
        }
    }
}
