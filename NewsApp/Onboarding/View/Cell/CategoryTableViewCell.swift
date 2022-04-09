//
//  CategoryTableViewCell.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var checkButton: UIButton!
    
    var didSelectCell: ((UITableViewCell)->())?
    
    func config(with category: Category) {
        categoryLabel.text = category.name
        category.isSelected ? checkCategory() : uncheckCategory()
    }
    
    private func checkCategory() {
        checkButton.tag = 1
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    }
    
    private func uncheckCategory() {
        checkButton.tag = 0
        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    @IBAction private func checkPressed(_ sender: UIButton) {
        if checkButton.tag == 0 {
            checkCategory()
        } else {
            uncheckCategory()
        }
        didSelectCell?(self)
    }
    
}
