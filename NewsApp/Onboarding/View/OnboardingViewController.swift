//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: BaseViewController {

    @IBOutlet weak private var countryPickerTextField: PickerTextField!
    @IBOutlet weak private var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        //register cell nib file
        registerCell()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
}

extension OnboardingViewController {
    private func registerCell() {
        let categoryCell = UINib(nibName: Constants.categoryCell, bundle: nil)
        categoriesTableView?.register(categoryCell, forCellReuseIdentifier: Constants.categoryCell)
    }
}
