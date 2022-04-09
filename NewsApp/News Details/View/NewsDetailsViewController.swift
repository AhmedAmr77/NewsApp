//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import UIKit
import SDWebImage

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var sourceLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        displayData()
    }
    
    @IBAction private func visitLinkPressed(_ sender: UIButton) {
        if let urlStr = article.url,
           let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        } else {
            sender.isHidden = true
        }
    }
}

extension NewsDetailsViewController {
    private func initView() {
        
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = #colorLiteral(red: 0.03529411765, green: 0.368627451, blue: 0.6705882353, alpha: 1)
    }
    
    private func displayData() {
        title = article.source.name
        imageView.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: Constants.placeholderImageName))
        titleLabel.text = article.title

        checkText(text: article.author) ? (authorLabel.text = article.author) : (authorLabel.superview?.isHidden = true)
        checkText(text: article.description) ? (descriptionLabel.text = article.description) : (descriptionLabel.superview?.isHidden = true)
    }
        
    private func checkText(text: String?) -> Bool {
        if let text = text,
           !text.isEmpty {
            return true
        }
        return false
    }
}
