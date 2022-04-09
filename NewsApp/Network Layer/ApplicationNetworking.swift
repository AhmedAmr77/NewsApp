//
//  ApplicationNetworking.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation
import Alamofire

enum ApplicationNetworking{
    case getNews(page:String, limit:String)
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
            return Constants.urlPath
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
        case .getNews(let page, let limit):
            return .requestParameters(parameters: ["page":page,"limit":limit], encoding: URLEncoding.default)
        }
    }
    var headers: [String : String]? {
        switch self{
        default:
            return ["Accept": "application/json","Content-Type": "application/json", "apiKey": Constants.apiKey]
        }
    }
}
