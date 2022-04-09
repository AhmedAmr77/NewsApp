//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation
import Alamofire

protocol NewsAPIContract {
    func getNews(page:String,limit:String,completion: @escaping (Result<NewsResponse?,NSError>) -> Void)
    func cancelAllRequests()
}

class NewsAPI : BaseAPI<ApplicationNetworking>, NewsAPIContract {
    
    //add protocol
    static let sharedInstance = NewsAPI()
    
    private override init() {}

    func getNews(page: String, limit: String, completion: @escaping (Result<NewsResponse?, NSError>) -> Void) {
        self.fetchData(target: .getNews(page: page, limit: limit), responseClass: NewsResponse.self) { (result) in
            completion(result)
        }
    }
    
    func cancelAllRequests() {
        self.cancelAnyRequest()
    }

}
