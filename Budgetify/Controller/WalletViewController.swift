//
//  StatisticViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 17/02/2023.
//

import UIKit
import Charts
import FirebaseAuth
import FirebaseFirestore

class WalletViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var walletTableView: UITableView!
    
    var numbers = [Double]()
    let xLabels: [String] = ["Mon","Tue","Wed"]
    var lineChartEntry = [ChartDataEntry]()
    var totalBalance: Double = 0.0
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser?.email
    var transactionList = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWalletData()
        loadTransactionList()
        loadUserBalance()
        
        //line chart view
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 0.5)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        
        chartContainerView.backgroundColor = UIColor(hex: 0xFBFBFB)
        chartContainerView.layer.cornerRadius = 20
        chartContainerView.layer.shadowColor = UIColor.black.cgColor
        chartContainerView.layer.shadowOpacity = 0.4
        chartContainerView.layer.shadowOffset = CGSize(width: 8, height: 8)
        
        //register cell
        let cellNib = UINib(nibName: "WalletTableViewCell", bundle: nil)
        walletTableView.register(cellNib, forCellReuseIdentifier: "WalletTableViewCell")
    }
    
    func loadWalletData() {
        db.collection("transaction")
            .getDocuments() { (querySnapshot,err) in
                if let e = err {
                    print("there was error getting data \(e)")
                } else {
                    if let snapshotDocs = querySnapshot?.documents {
                        for doc in snapshotDocs {
                            let data = doc.data()
                            let type = data["type"] as! String
                            let amount = Double(data["amount"] as! String)
                            let userEmail = data["user"] as! String
                            
                            if Auth.auth().currentUser?.email == userEmail {
                                if type == "Expense" {
                                    self.totalBalance -= amount!
                                } else if querySnapshot?.documents.count == 0 {
                                    print("no document")
                                } else {
                                    self.totalBalance += amount!
                                }
                                self.numbers.append(self.totalBalance)
                                
                                DispatchQueue.main.async {
                                    for i in 0..<self.numbers.count {

                                        let value = ChartDataEntry(x: Double(i), y: self.numbers[i])
                                        self.lineChartEntry.append(value)
                                    }
                                    
                                    let line1 = LineChartDataSet(entries: self.lineChartEntry,label: "transactions")
                                    line1.colors = [NSUIColor(hex: 0x438883)]
                                    line1.drawCirclesEnabled = false
                                    line1.mode = .linear
                                    line1.lineWidth = 3
                                    line1.fill = ColorFill(color: NSUIColor(hex: 0x438883))
                                    line1.fillAlpha = CGFloat(0.1)
                                    line1.drawFilledEnabled = true

                                    let data = LineChartData()
                                    data.append(line1)
                                    self.lineChartView.data = data
                                    self.balanceLabel.text = "$ "+String(self.numbers.last ?? 0.0)
                                }
                            }
                        }
                    }
                }
            }
    }

}

extension WalletViewController {
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
                                        self.walletTableView.reloadData()
                                    }
                                }
                            }
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
                            
                            self.totalBalance = balance ?? 0.0
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.balanceLabel.text = "$ "+String(self.totalBalance)
                }
            }
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as! WalletTableViewCell
        cell.configCell(transaction: transactionList[indexPath.row])
        return cell
    }
}
