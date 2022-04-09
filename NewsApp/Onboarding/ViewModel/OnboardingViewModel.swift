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
    
    private var countriesModel: Countries?
    private var countries: [String]?
    private var categories: [Category]?
    
    private let defaults = UserDefaults.standard
        
    init() {
        countriesObservable = countriesSubject.asObservable()
        categoriesObservable = categoriesSubject.asObservable()
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        dismissObservable = dismissSubject.asObservable()
        
        countriesModel = Countries()
        countries = countriesModel?.getCountriesNames()
        
        categories = Categories().categories
    }
    
    func getData() {
        guard categories != nil,
              countries != nil else { errorSubject.onNext(Constants.somethingWrong); return }
        loadingSubject.onNext(true)
        countriesSubject.onNext(countries!)
        categoriesSubject.onNext(categories!)
        loadingSubject.onNext(false)
    }
    
    func didSelectCountry(at index: Int) {
        selectedCountry = countriesModel?.getCode(for: countries?[index] ?? "")?.lowercased()
    }
    
    func updateCategory(at index: Int) {
        guard categories != nil else { errorSubject.onNext(Constants.somethingWrong); return }
        loadingSubject.onNext(true)
        categories![index].isSelected = !categories![index].isSelected
        categoriesSubject.onNext(categories!)
        loadingSubject.onNext(false)
    }
    
    func donePressed() {
        if !checkCountryIsSelected() {
            errorSubject.onNext(Constants.selectCountryMessage)
        } else if !checkCategoryIsSelected() {
            errorSubject.onNext(Constants.selectCategoryMessage)
        } else {
            // save country and categories
            defaults.set(selectedCountry, forKey: Constants.countryLocalKey)
            defaults.set(getSelectedCategories(), forKey: Constants.categoryLocalKey)
             
            dismissSubject.onNext(())
        }
    }
    
    private func checkCountryIsSelected() -> Bool {
        (selectedCountry != nil) ? true : false
    }
    
    private func checkCategoryIsSelected() -> Bool {
        guard categories != nil else { return false }
        for category in categories! {
            if category.isSelected {
                return true
            }
        }
        return false
    }
    
    private func getSelectedCategories() -> [String] {
        guard categories != nil else { return [] }
        var selectedCategries = [String]()
        for category in categories! {
            if category.isSelected {
                selectedCategries.append(category.name)
            }
        }
        return selectedCategries
    }
}
