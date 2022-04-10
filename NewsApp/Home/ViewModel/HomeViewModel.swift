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
    var errorObservable: Observable<(String)> { get }
    var loadingObservable: Observable<Bool> { get }
    var searchValue: BehaviorRelay<String> { get }
    var refreshControlAction: PublishSubject<Void> { get }
    var fetchMoreDatas: PublishSubject<Void> { get }
    var refreshControlCompelted: PublishSubject<Void> { get }
    var isLoadingSpinnerAvaliable: PublishSubject<Bool> { get }
    var items: BehaviorRelay<[Article]> { get }
}

class HomeViewModel: HomeViewModelProtocol {
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
    private lazy var searchValueObservable: Observable<String> = searchValue.asObservable()

    private var maxValue: Int?
    private var pageCounter = 1
    private var limit = 10
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
            self.items.accept(self.searchedData ?? [])
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
        isPaginationRequestStillResume = false
        pageCounter = 1
        items.accept([])
        fetchData(page: pageCounter,
                       isRefreshControl: true)
    }
    
    private func fetchData(page: Int, isRefreshControl: Bool) {
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
        
        if userDefaults.isLastNewsRequestPassed() || (pageCounter != 1) {
            self.loadingsubject.onNext(true)
            newsAPI.getNews(country: country!, category: categories![0], page: String(pageCounter), limit: String(limit)) { [weak self] (result) in
                guard let self = self else { print("HVM getNews failed"); return }
                switch result{
                case .success(let response):
                    self.maxValue = (Int((response?.totalResults ?? 0) / self.limit) + 1)
                    self.handleData(data: response?.articles)
                case .failure(_):
                    self.getCachedNews()
                }
            }
        } else {
            getCachedNews()
        }
        self.loadingsubject.onNext(false)
        self.isLoadingSpinnerAvaliable.onNext(false)
        self.isPaginationRequestStillResume = false
        self.isRefreshRequstStillResume = false
        self.refreshControlCompelted.onNext(())
    }
    
    private func handleData(data: [Article]?) {
        print("in handle data")
        if pageCounter == 1, let newD = data, !newD.isEmpty {
            newsCache.deleteAll()
            print("HD pc !=1")
            items.accept(newD)
        } else if let newD = data, !newD.isEmpty {
            let oldDatas = items.value
            items.accept(oldDatas + newD)
        }
        saveArticlesToLocal(data ?? [])
        userDefaults.setLastNewsRequest()

        self.articles = items.value
        pageCounter += 1
    }

    private func getUserSelections() {
        country = userDefaults.getCountry() ?? ""
        categories = userDefaults.getCategories() ?? []
    }
    
    private func getCachedNews() {
        newsCache.getNews(completion: { [weak self] (articlesArray) in
            guard let self = self else { return }
            if !articlesArray.isEmpty {
                self.items.accept([])
                self.items.accept(articlesArray)
            } else {
                self.errorsubject.onNext(Constants.noInternetConnection)
            }
        })
    }
    
    private func saveArticlesToLocal(_ newAtricles: [Article]) {
        newAtricles.forEach { (article) in
            newsCache.save(article: article)
        }
    }
}
