//
//  WalletTableViewCell.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 23/02/2023.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(transaction: Transaction) {
        descLabel.text = transaction.description
        
        if transaction.type == "Income" {
            amountLabel.text = "+ $ \(transaction.amount!)"
        } else {
            amountLabel.text = "- $ \(transaction.amount!)"
            amountLabel.textColor = UIColor.red
            dateLabel.text = transaction.date
        }
    }
    
}
