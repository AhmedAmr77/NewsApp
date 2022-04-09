//
//  LocalUserDefaults.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation

class LocalUserDefaults{
    static let sharedInstance = LocalUserDefaults()
    private var userDefaults:UserDefaults
    
    private init(){
        userDefaults = UserDefaults.standard
    }
    
    func setLastNewsRequest() {
        userDefaults.set(Date(), forKey: Constants.lastRequestKey)
    }
    
    func isLastNewsRequestPassed() -> Bool {
        if let lastRequest = userDefaults.object(forKey: Constants.lastRequestKey) as? Date,
           let diff = Calendar.current.dateComponents([.minute], from: lastRequest, to: Date()).minute,
           diff < 30 {
            return false
        }
        return true
    }
    
    func setCountry(_ country: String?) {
        userDefaults.set(country, forKey: Constants.countryLocalKey)
    }
    
    func getCountry() -> String? {
        userDefaults.string(forKey: Constants.countryLocalKey)
    }
    
    func setCategories(_ categories: [String]) {
        userDefaults.set(categories, forKey: Constants.categoryLocalKey)
    }
    
    func getCategories() -> [String]? {
        userDefaults.stringArray(forKey: Constants.categoryLocalKey)
    }
}
