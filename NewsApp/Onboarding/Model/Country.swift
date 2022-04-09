//
//  Country.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import Foundation

struct Country: Decodable {
    let name: String
    let code: String
}

struct Countries {
    var countries: [Country]
    
    init() {
        countries = []
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: CountriesJSON, options: .fragmentsAllowed)
            countries = try JSONDecoder().decode([Country].self, from: jsonData)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getCountriesNames() -> [String] {
        var names = [String]()
        countries.forEach { (country) in
            names.append(country.name)
        }
        return names
    }
    
    func getCode(for name: String) -> String? {
        for country in countries {
            if country.name == name {
                return country.code
            }
        }
        return .none
    }
    
    private let CountriesJSON: [[String:String]] = [
        ["name": "Argentina", "code": "AR"],
        ["name": "Australia", "code": "AU"],
        ["name": "Belgium", "code": "BE"],
        ["name": "Brazil", "code": "BR"],
        ["name": "Bulgaria", "code": "BG"],
        ["name": "Canada", "code": "CA"],
        ["name": "China", "code": "CN"],
        ["name": "Colombia", "code": "CO"],
        ["name": "Cuba", "code": "CU"],
        ["name": "Czech Republic", "code": "CZ"],
        ["name": "Egypt", "code": "EG"],
        ["name": "France", "code": "FR"],
        ["name": "Germany", "code": "DE"],
        ["name": "Greece", "code": "GR"],
        ["name": "Hong Kong", "code": "HK"],
        ["name": "Hungary", "code": "HU"],
        ["name": "India", "code": "IN"],
        ["name": "Indonesia", "code": "ID"],
        ["name": "Ireland", "code": "IE"],
        ["name": "Israel", "code": "IL"],
        ["name": "Italy", "code": "IT"],
        ["name": "Japan", "code": "JP"],
        ["name": "Latvia", "code": "LV"],
        ["name": "Lithuania", "code": "LT"],
        ["name": "Malaysia", "code": "MY"],
        ["name": "Mexico", "code": "MX"],
        ["name": "Morocco", "code": "MA"],
        ["name": "Netherlands", "code": "NL"],
        ["name": "New Zealand", "code": "NZ"],
        ["name": "Nigeria", "code": "NG"],
        ["name": "Norway", "code": "NO"],
        ["name": "Philippines", "code": "PH"],
        ["name": "Poland", "code": "PL"],
        ["name": "Portugal", "code": "PT"],
        ["name": "Romania", "code": "RO"],
        ["name": "Russia", "code": "RU"],
        ["name": "Saudi Arabia", "code": "SA"],
        ["name": "Serbia", "code": "RS"],
        ["name": "Singapore", "code": "SG"],
        ["name": "Slovakia", "code": "SK"],
        ["name": "Slovenia", "code": "SI"],
        ["name": "South Africa", "code": "ZA"],
        ["name": "South Korea", "code": "KR"],
        ["name": "Sweden", "code": "SE"],
        ["name": "Switzerland", "code": "CH"],
        ["name": "Taiwan", "code": "TW"],
        ["name": "Thailand", "code": "TH"],
        ["name": "Turkey", "code": "TR"],
        ["name": "Ukraine", "code": "UA"],
        ["name": "United Arab Emirates", "code": "AE"],
        ["name": "United Kingdom", "code": "GB"],
        ["name": "United States", "code": "US"],
        ["name": "Venezuela", "code": "VE"],
    ]
}
