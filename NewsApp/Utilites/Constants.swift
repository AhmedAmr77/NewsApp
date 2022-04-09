//
//  Constants.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import Foundation

struct Constants {

    //MARK:- Onboarding
    static let categoryCell = "CategoryTableViewCell"
    
    static let selectCountryMessage = "Please select your country!"
    static let selectCategoryMessage = "Please select at least one category!"
    static let somethingWrong = "Something wrong happened please try again later"

    //MARK:- Home
    static let newsTitle = "NEWS"
    static let newsCell = "NewsTableViewCell"
    static let placeholderImageName = "placeholder"
    
    //MARK:- Local
    static let countryLocalKey = "Country"
    static let categoryLocalKey = "Category"
    static let localDomain = "LocalDomain"
    static let noNewsError = "No News Found"
    static let entityName = "NewsArticle"
    static let articleSourceNameKey = "sourceName"
    static let articleAuthorKey = "author"
    static let articleTitleKey = "title"
    static let articleDescriptionKey = "artDescription"
    static let articleImageUrlKey = "imageUrl"
    static let articleUrlKey = "url"
    
    static let lastRequestKey = "LastRequest"
    
    //MARK:- Networking
    static let baseURL = "https://newsapi.org/"
    static let headlinesUrlPath = "v2/top-headlines"
    static let apiKey = "2a8b1ffdb9ba4d36a14e4cead2ca29f2"
    
    static let apiKeyKey = "apiKey"
    static let countryKey = "country"
    static let categoryKey = "category"
    static let pageKey = "page"
    static let pageSizeKey = "pageSize"
    static let searchyKey = "q"

    static let noInternetConnection = "No Internet Connection, Please check your connection and try again."
    static let genericError = "General Error occured, kindly try again later"
    static let serverError = "Error Message Parsed From Server"
}
