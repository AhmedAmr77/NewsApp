//
//  Article.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
}
