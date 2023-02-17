//
//  TransactionTableViewCell.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 13/02/2023.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let currency = "$"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(transaction: Transaction) {
        descLabel.text = transaction.description
        
        if transaction.type == "Income" {
            amountLabel.text = "+ \(currency) \(transaction.amount!)"
        } else {
            amountLabel.text = "- \(currency) \(transaction.amount!)"
            amountLabel.textColor = UIColor.red
            dateLabel.text = transaction.date
        }
    }
    
}
