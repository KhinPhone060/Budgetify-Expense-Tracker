//
//  statisticTableViewCell.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 19/02/2023.
//

import UIKit

class statisticTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = UIColor(hex: 0xFBFBFB)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(category: Category) {
        categoryLabel.text = category.name
        amountLabel.text = "- $ \(category.totalAmount)"
        
        switch category.name {
        case "Bill":
            categoryImage.image = UIImage(systemName: "dollarsign.circle.fill")
            categoryImage.tintColor = UIColor(hex: 0xFF0000)
        case "Shopping":
            categoryImage.image = UIImage(named: "shopping")
            categoryImage.tintColor = UIColor(hex: 0xFF7200)
        case "Tax":
            categoryImage.image = UIImage(named: "tax")
            categoryImage.tintColor = UIColor(hex: 0xFFAE00)
        case "Food & Drinks":
            categoryImage.image = UIImage(named: "drink")
            categoryImage.tintColor = UIColor(hex: 0xFFEC00)
        case "Housing":
            categoryImage.image = UIImage(named: "housing")
            categoryImage.tintColor = UIColor(hex: 0x2CCB75)
        case "Transportation":
            categoryImage.image = UIImage(named: "transportation")
            categoryImage.tintColor = UIColor(hex: 0x5FB7D4)
        case "Vehicle":
            categoryImage.image = UIImage(named: "vehicle")
            categoryImage.tintColor = UIColor(hex: 0x007ED6)
        case "Life & Entertainment":
            categoryImage.image = UIImage(named: "entertainment")
            categoryImage.tintColor = UIColor(hex: 0x8E6BEF)
        case "Communication":
            categoryImage.image = UIImage(named: "communication")
            categoryImage.tintColor = UIColor(hex: 0x9C46D0)
        case "Investment":
            categoryImage.image = UIImage(named: "investment")
            categoryImage.tintColor = UIColor(hex: 0xE01D84)
        default:
            print("no category")
        }
        
    }
}
