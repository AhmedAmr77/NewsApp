//
//  Protocols.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import Foundation
import RxSwift

protocol BaseViewModelProtocol {
    var errorObservable: Observable<String> { get }
    var loadingObservable: Observable<Bool> { get }
}
