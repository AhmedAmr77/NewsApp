//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation
import Alamofire

protocol NewsAPIContract {
    func getNews(country: String, category:String, page:String, limit:String, completion: @escaping (Result<NewsResponse?,NSError>) -> Void)
    func cancelAllRequests()
}

class NewsAPI : BaseAPI<ApplicationNetworking>, NewsAPIContract {
    
    //add protocol
    static let sharedInstance = NewsAPI()
    
    private override init() {}

    func getNews(country: String, category: String, page: String, limit: String, completion: @escaping (Result<NewsResponse?, NSError>) -> Void) {
        self.fetchData(
            target: .getNews(country: country, category: category, page: page, limit: limit),
            responseClass: NewsResponse.self) { (result) in
            completion(result)
        }
    }
    
    func searchNews(with keyword: String, page: String, limit: String, completion: @escaping (Result<NewsResponse?, NSError>) -> Void) {
        self.fetchData(
            target: .searchNews(keyword: keyword, page: page, limit: limit),
            responseClass: NewsResponse.self) { (result) in
            completion(result)
        }
    }
    
    func cancelAllRequests() {
        self.cancelAnyRequest()
    }

}
