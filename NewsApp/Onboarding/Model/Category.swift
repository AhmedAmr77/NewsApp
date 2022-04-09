//
//  Category.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import Foundation

struct Category {
    let name: String
    var isSelected: Bool
}

struct Categories {
    let categories = [Category(name: "business", isSelected: false),
                      Category(name: "entertainment", isSelected: false),
                      Category(name: "general", isSelected: false),
                      Category(name: "health", isSelected: false),
                      Category(name: "science", isSelected: false),
                      Category(name: "sports", isSelected: false),
                      Category(name: "technology", isSelected: false)]
}
