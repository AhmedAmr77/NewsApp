//
//  ApplicationNetworking.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation
import Alamofire

enum ApplicationNetworking{
    case getNews(country:String, category:String, page:String, limit:String)
    case searchNews(keyword:String, page:String, limit:String)
}

extension ApplicationNetworking : TargetType{
    var baseURL: String {
        switch self{
        default:
            return Constants.baseURL
        }
    }
    
    var path: String {
        switch self{
        case .getNews:
            return Constants.headlinesUrlPath
        case .searchNews:
            return Constants.headlinesUrlPath
        }
    }
    
    var method: HTTPMethod {
        switch self{
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .getNews(let country, let category, let page, let limit):
            return .requestParameters(
                parameters: [Constants.countryKey:country, Constants.categoryKey:category, Constants.pageKey:page, Constants.pageSizeKey:limit],
                encoding: URLEncoding.default)
        case .searchNews(let keyword, let page, let limit):
            return .requestParameters(
                parameters: [Constants.searchyKey:keyword,Constants.pageKey:page,Constants.pageSizeKey:limit],
                encoding: URLEncoding.default)
        }
    }
    var headers: [String : String]? {
        switch self{
        default:
            return ["Accept": "application/json","Content-Type": "application/json"]
        }
    }
}
