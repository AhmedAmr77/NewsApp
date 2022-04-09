//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak private var countryPickerTextField: PickerTextField!
    @IBOutlet weak private var categoriesTableView: UITableView!
    @IBOutlet weak private var doneButton: UIButton!
    
    private var disposeBag: DisposeBag!
    private var viewModel: OnboardingViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsAPI.sharedInstance.getNews(country: "eg", category: "sports", page: "1", limit: "7") { (result) in
            switch result {
            case.failure(let err):
                print("EERRORR1 =>", err)
            case.success(let response):
                print("SSUCCESS1", response)
            }
        }
        NewsAPI.sharedInstance.searchNews(with: "salah", page: "1", limit: "7") { (result) in
            switch result {
            case.failure(let err):
                print("EERRORR2 =>", err)
            case.success(let response):
                print("SSUCCESS2", response)
            }
        }
        
        viewInit()
        
        //register cell nib file
        registerCell()
        
        //initialization
        viewModel = OnboardingViewModel()
        disposeBag = DisposeBag()
        
        //setting delegate
        categoriesTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //bindingData from viewModel
        binding()
        
        //listen while getting data
        subscribing()
        
        //get categories
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        viewModel.donePressed()
    }
    
    @objc private func dismissKeyboard () {
        let _ = countryPickerTextField.resignFirstResponder()
    }
}

extension OnboardingViewController {
    private func viewInit() {
        doneButton.layer.cornerRadius = 10
        doneButton.layer.borderWidth = 1.5
        categoriesTableView.tableFooterView = UIView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func registerCell() {
        let categoryCell = UINib(nibName: Constants.categoryCell, bundle: nil)
        categoriesTableView.register(categoryCell, forCellReuseIdentifier: Constants.categoryCell)
    }
    
    private func binding() {
        viewModel.categoriesObservable.bind(to: categoriesTableView.rx.items(cellIdentifier: Constants.categoryCell)) {row, item, cell in
            let castedCell = cell as! CategoryTableViewCell
            castedCell.config(with: item)
         castedCell.didSelectCell = { [weak self] (cell) in
            guard let self = self,
                let index = self.categoriesTableView.indexPath(for: cell)?.row else { return }
            if self.countryPickerTextField.isFirstResponder {
                self.dismissKeyboard()
            }
            self.viewModel.updateCategory(at: index)
         }
        }.disposed(by: disposeBag)
    }
    
    private func subscribing() {
        viewModel.countriesObservable.subscribe(onNext: {[weak self] (countries) in
            guard let self = self else { return }
            self.countryPickerTextField.dataList = countries
            self.countryPickerTextField.didSelect = { [weak self] (index) in
                guard let self = self else { return }
                self.viewModel.didSelectCountry(at: index)
            }
        }).disposed(by: disposeBag)
        
        viewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else { return }
            self.showAlert(message)
        }).disposed(by: disposeBag)
        
        viewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else { return }
            switch boolValue{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        viewModel.dismissObservable.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
