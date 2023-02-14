//
//  ViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 11/02/2023.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var walletCardView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    var transactionList = [Transaction]()
    var totalBalance: Float = 0.0
    var totalIncome: Float = 0.0
    var totalExpense: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletCardView.layer.cornerRadius = 20
        walletCardView.layer.shadowColor = UIColor(named: "BackgroundColor")?.cgColor
        walletCardView.layer.shadowOpacity = 0.4
        walletCardView.layer.shadowOffset = CGSize(width: 8, height: 8)
        
        loadTransactionList()
        calculateTotalBalance()
        
        //register cell
        let cellNib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        transactionTableView.register(cellNib, forCellReuseIdentifier: "TransactionTableViewCell")
        
        totalBalanceLabel.text = "$ "+String(totalBalance)
        incomeLabel.text = "$ "+String(totalIncome)
        expenseLabel.text = "$ "+String(totalExpense)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.configCell(transaction: transactionList[indexPath.row])
        return cell
    }
}

extension HomeViewController {
    func loadTransactionList() {
        
    }
    
    func calculateTotalBalance() {
//        for transaction in transactionList {
//            if transaction.type == "Income" {
//                totalIncome += Float(transaction.amount!)!
//            } else {
//                totalExpense += Float(transaction.amount!)!
//            }
//        }
//        totalBalance += totalIncome
//        totalBalance -= totalExpense
    }
    
}

