//
//  ViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 11/02/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var walletCardView: UIView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    var transactionList = [Transaction]()
    
    var totalBalance: Double = 0.0
    var totalIncome: Double = 0.0
    var totalExpense: Double = 0.0
    var displayName: String = ""
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil {
            self.navigateToSignUp()
        } else {
            loadTransactionList()
            loadTotalExpense()
            loadTotalIncome()
            loadUserBalance()
            
            walletCardView.layer.cornerRadius = 20
            walletCardView.layer.shadowColor = UIColor(named: "BackgroundColor")?.cgColor
            walletCardView.layer.shadowOpacity = 0.4
            walletCardView.layer.shadowOffset = CGSize(width: 8, height: 8)
            
            //register cell
            let cellNib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
            transactionTableView.register(cellNib, forCellReuseIdentifier: "TransactionTableViewCell")
        }
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
            .order(by: Constants.Fstore.timeAdded ,descending: true)
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
                               let type = data["type"] as? String,
                               let date = data["date"] as? String,
                               let user = data[Constants.Fstore.user] as? String
                            {
                                if Auth.auth().currentUser?.email == user {
                                    let newTransaction = Transaction(type: type, category: category, amount: amount, description: description, date: date)
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
                            
                            if let user = data["user"] as? String {
                                if Auth.auth().currentUser?.email == user {
                                    let income = Double(data["amount"] as! String)
                                    
                                    guard income != nil else {
                                        return
                                    }
                                    self.totalIncome += income!
                                }
                            }
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
                            
                            if let user = data["user"] as? String {
                                if Auth.auth().currentUser?.email == user {
                                    let expense = Double(data["amount"] as! String)
                                    
                                    guard expense != nil else {
                                        return
                                    }
                                    self.totalExpense += expense!
                                }
                            }
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
    
    func loadUserBalance() {
        db.collection("user")
            .whereField("user", isEqualTo: currentUser!)
            .getDocuments() { querySnapshot, err in
                if let e = err {
                    print("There was problem retrieving data from the firestore \(e)")
                } else if querySnapshot?.documents.count == 0 {
                    print("no user")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let balance = Double(((data["balance"] as? String)!))
                            let userName = data["userName"] as? String
                            
                            self.totalBalance = balance ?? 0.0
                            self.displayName = userName!
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.totalBalanceLabel.text = "$ "+String(self.totalBalance)
                    self.displayNameLabel.text = self.displayName
                }
            }
    }
}
