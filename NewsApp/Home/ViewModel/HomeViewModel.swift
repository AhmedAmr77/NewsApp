//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation
import RxSwift

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    var newsObservable: Observable<[Article]> { get }
    var errorObservable: Observable<(String)> { get }
    var loadingObservable: Observable<Bool> { get }
    func getData()
}

class HomeViewModel: HomeViewModelProtocol {
    var newsObservable: Observable<[Article]>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>

    private var errorsubject = PublishSubject<String>()
    private var loadingsubject = PublishSubject<Bool>()
    private var newsSubject = PublishSubject<[Article]>()

    private var page = "1"
    private var limit = "15"
    private var country: String?
    private var categories: [String]?

    private let newsAPI: NewsAPIContract!
    private let defaults = UserDefaults.standard
    
    init() {        
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        newsObservable = newsSubject.asObservable()
        
        newsAPI = NewsAPI.sharedInstance

        getUserSelections()
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
                    self.newsSubject.onNext(response?.articles ?? [])
                case .failure(let error):
                    self.errorsubject.onNext(error.localizedDescription)
                }
            }
        }
    }
}
