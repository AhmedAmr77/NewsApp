//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerInit()
    }

    func spinnerInit() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
}

extension BaseViewController {
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showAlert(_ title: String, with message: String? = nil, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            actions.forEach { (action) in
                alertController.addAction(action)
            }
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        present(alertController, animated: true, completion: nil)
    }
}
