//
//  OnboardingViewModel.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import Foundation
import RxSwift

protocol OnboardingViewModelProtocol: BaseViewModelProtocol {
    var countriesObservable: Observable<[String]> { get }
    var categoriesObservable: Observable<[Category]> { get }
    var dismissObservable: Observable<Void> { get }
    func getData()
    func didSelectCountry(at index: Int)
    func updateCategory(at index: Int)
    func donePressed()
}

class OnboardingViewModel: OnboardingViewModelProtocol {
    
    var countriesObservable: Observable<[String]>
    var categoriesObservable: Observable<[Category]>
    var errorObservable: Observable<String>
    var loadingObservable: Observable<Bool>
    var dismissObservable: Observable<Void>

    private var countriesSubject = PublishSubject<[String]>()
    private var categoriesSubject = PublishSubject<[Category]>()
    private var errorSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()
    private var dismissSubject = PublishSubject<Void>()
    
    private var selectedCountry: String?
    
    private var countries = ["EUA", "Egypt", "KSA", "Aus", "UK", "USA", "GER", "Russ", "Mex", "io", "op"]
    private var categories = [Category(name: "Bis", isSelected: false),
                              Category(name: "Spo", isSelected: false),
                              Category(name: "Sci", isSelected: false),
                              Category(name: "Tec", isSelected: false),
                              Category(name: "hea", isSelected: false)]
        
    init() {
        countriesObservable = countriesSubject.asObservable()
        categoriesObservable = categoriesSubject.asObservable()
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        dismissObservable = dismissSubject.asObservable()
    }
    
    func getData() {
        loadingSubject.onNext(true)
        countriesSubject.onNext(countries)
        categoriesSubject.onNext(categories)
        loadingSubject.onNext(false)
    }
    
    func didSelectCountry(at index: Int) {
        selectedCountry = countries[index]
    }
    
    func updateCategory(at index: Int) {
        loadingSubject.onNext(true)
        categories[index].isSelected = !categories[index].isSelected
        categoriesSubject.onNext(categories)
        loadingSubject.onNext(false)
    }
    
    func donePressed() {
        if !checkCountryIsSelected() {
            errorSubject.onNext("Please select your country!")
        } else if !checkCategoryIsSelected() {
            errorSubject.onNext("Please select at least one category!")
        } else {
            
            // save country and categories
             
            dismissSubject.onNext(())
        }
    }
    
    private func checkCountryIsSelected() -> Bool {
        (selectedCountry != nil) ? true : false
    }
    
    private func checkCategoryIsSelected() -> Bool {
        for category in categories {
            if category.isSelected {
                return true
            }
        }
        return false
    }
}
