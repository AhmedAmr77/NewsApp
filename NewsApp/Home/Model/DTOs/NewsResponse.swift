//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
