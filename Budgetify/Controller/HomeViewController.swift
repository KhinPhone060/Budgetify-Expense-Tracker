//
//  ViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 11/02/2023.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var walletCardView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    var transactionList = [Transaction]()
    
    var totalBalance: Float = 20000.0
    var totalIncome: Float = 0.0
    var totalExpense: Float = 0.0
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTransactionList()
        loadTotalIncome()
        loadTotalExpense()
        
        walletCardView.layer.cornerRadius = 20
        walletCardView.layer.shadowColor = UIColor(named: "BackgroundColor")?.cgColor
        walletCardView.layer.shadowOpacity = 0.4
        walletCardView.layer.shadowOffset = CGSize(width: 8, height: 8)
        
        //register cell
        let cellNib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        transactionTableView.register(cellNib, forCellReuseIdentifier: "TransactionTableViewCell")
        
    }
}

//MARK: - UITableView Delegate & Datasource
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
        db.collection("transaction")
            .order(by: Constants.Fstore.date ,descending: true)
            .addSnapshotListener { (querySnapshot, err) in
                
                self.transactionList = []
                
                if let e = err {
                    print("There was problem retrieving data from the firestore \(e)")
                } else {
                    if let snapShotDocuments =  querySnapshot?.documents {
                        for doc in snapShotDocuments {
                            let data =  doc.data()
                            if let amount = data["amount"] as? String,
                               let category = data["category"] as? String,
                               let description = data["description"] as? String,
                               let type = data["type"] as? String
                            {
                                let newTransaction = Transaction(type: type, category: category, amount: amount, description: description)
                                self.transactionList.append(newTransaction)
                                
                                DispatchQueue.main.async {
                                    self.transactionTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func loadTotalIncome() {
        db.collection("transaction")
            .whereField("type", isEqualTo: "Income")
            .getDocuments() { querySnapshot, error in
                if let e = error {
                    print("There was problem retrieving data from the firestore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            var income = Float(data["amount"] as! String)
                            
                            self.totalIncome += income!
                        }
                        self.totalBalance += self.totalIncome
                        
                        DispatchQueue.main.async {
                            self.totalBalanceLabel.text = "$ "+String(self.totalBalance)
                            self.incomeLabel.text = "$ "+String(self.totalIncome)
                            self.expenseLabel.text = "$ "+String(self.totalExpense)
                        }
                    }
                    
                }
            }
    }
    
    func loadTotalExpense() {
        db.collection("transaction")
            .whereField("type", isEqualTo: "Expense")
            .getDocuments() { querySnapshot, error in
                if let e = error {
                    print("There was problem retrieving data from the firestore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            var income = Float(data["amount"] as! String)
                            
                            self.totalExpense += income!
                        }
                        self.totalBalance -= self.totalExpense
                        
                        DispatchQueue.main.async {
                            self.totalBalanceLabel.text = "$ "+String(self.totalBalance)
                            self.incomeLabel.text = "$ "+String(self.totalIncome)
                            self.expenseLabel.text = "$ "+String(self.totalExpense)
                        }
                    }
                    
                }
            }
    }
}
