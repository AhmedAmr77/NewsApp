//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/9/22.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak private var newsImageView: UIImageView!
    @IBOutlet weak private var descreptionLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 10
        selectionStyle = .none
    }
    
    func config(with article: Article) {
        newsImageView.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: Constants.placeholderImageName))
        descreptionLabel.text = article.description
    }
}
