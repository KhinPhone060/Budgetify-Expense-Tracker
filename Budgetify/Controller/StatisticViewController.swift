//
//  WalletViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 17/02/2023.
//

import UIKit
import Charts
import FirebaseFirestore
import FirebaseAuth
import iOSDropDown

class StatisticViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var monthDropDown: DropDown!
    @IBOutlet weak var tableview: UITableView!
    
    let db = Firestore.firestore()
    var categoryList = [Category]()

    var bill:Double = 0.0
    var shopping: Double = 0.0
    var tax: Double = 0.0
    var foodAndDrinks:Double = 0.0
    var housing:Double = 0.0
    var transportation:Double = 0.0
    var vehicle:Double = 0.0
    var lifeAndEntertainment:Double = 0.0
    var communicationAndPC:Double = 0.0
    var investment:Double = 0.0
    var totalExpense: Double = 0.0
    
    var entries: [PieChartDataEntry] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //drop down cofig
        monthDropDown.text = "Month"
        monthDropDown.optionArray = ["Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        monthDropDown.didSelect {selectedText,index,id in
            self.loadMonthlyTransactionData()
        }
        
        //pie chart
        pieChartView.chartDescription.enabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.isUserInteractionEnabled = false
        pieChartView.legend.enabled = false
        
        //load data
        loadMonthlyTransactionData()
        
        //register cell
        let cellNib = UINib(nibName: "statisticTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "statisticTableViewCell")
    }
    
    func loadMonthlyTransactionData() {
        self.monthDropDown.didSelect{ selectedText,index,id in
            self.db.collection("transaction")
                .whereField("month", isEqualTo: selectedText)
                .whereField("year", isEqualTo: "2023")
                .getDocuments() { (querySnapshot,err) in
                    if let e = err {
                        print("there was error getting data \(e)")
                    } else if querySnapshot?.documents.count == 0 {
                        self.entries = []
                        self.categoryList = []
                        let dataSet = PieChartDataSet(entries: self.entries, label: "")
                        self.pieChartView.data = PieChartData(dataSet: dataSet)
                        self.pieChartView.centerText = "No Chart Data"
                        self.tableview.reloadData()
                    } else {
                        self.entries = []
                        self.categoryList = []
                        self.bill = 0.0
                        self.shopping = 0.0
                        self.tax = 0.0
                        self.foodAndDrinks = 0.0
                        self.housing = 0.0
                        self.transportation = 0.0
                        self.vehicle = 0.0
                        self.lifeAndEntertainment = 0.0
                        self.communicationAndPC = 0.0
                        self.investment = 0.0
                        self.totalExpense = 0.0
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                let expense = Double(data["amount"] as! String)
                                let type = data["type"] as! String
                                let category = data["category"] as! String
                                let userEmail = data["user"] as! String
                                
                                if Auth.auth().currentUser?.email == userEmail {
                                    if type == "Expense" {
                                        switch category {
                                        case "Bill":
                                            self.bill += expense!
                                        case "Shopping":
                                            self.shopping += expense!
                                        case "Tax":
                                            self.tax += expense!
                                        case "Food & Drinks":
                                            self.foodAndDrinks += expense!
                                        case "Housing":
                                            self.housing += expense!
                                        case "Transportation":
                                            self.transportation += expense!
                                        case "Vehicle":
                                            self.vehicle += expense!
                                        case "Life & Entertainment":
                                            self.lifeAndEntertainment += expense!
                                        case "Communication":
                                            self.communicationAndPC += expense!
                                        case "Investment":
                                            self.investment += expense!
                                        default:
                                            print("nocategory")
                                        }
                                    }
                                }
                            }
                            let newCategory1 = Category(name: "Bill",totalAmount: self.bill)
                            let newCategory2 = Category(name: "Shopping",totalAmount: self.shopping)
                            let newCategory3 = Category(name: "Tax",totalAmount: self.tax)
                            let newCategory4 = Category(name: "Food & Drinks",totalAmount: self.foodAndDrinks)
                            let newCategory5 = Category(name: "Housing",totalAmount: self.housing)
                            let newCategory6 = Category(name: "Transportation",totalAmount: self.transportation)
                            let newCategory7 = Category(name: "Vehicle",totalAmount: self.vehicle)
                            let newCategory8 = Category(name: "Life & Entertainment",totalAmount: self.lifeAndEntertainment)
                            let newCategory9 = Category(name: "Communication",totalAmount: self.communicationAndPC)
                            let newCategory10 = Category(name: "Investment",totalAmount: self.investment)
                            let newCategories = [newCategory1,newCategory2,newCategory3,newCategory4,newCategory5,newCategory6,newCategory7,newCategory8,newCategory9,newCategory10]
                            
                            self.categoryList.append(contentsOf: newCategories)
                            
                            self.totalExpense = self.bill+self.shopping+self.tax+self.foodAndDrinks+self.housing+self.transportation+self.vehicle+self.lifeAndEntertainment+self.communicationAndPC+self.investment
                            self.entries.append(PieChartDataEntry(value: self.bill, label: "Bill"))
                            self.entries.append(PieChartDataEntry(value: self.shopping, label: "Shopping"))
                            self.entries.append(PieChartDataEntry(value: self.tax, label: "Tax"))
                            self.entries.append(PieChartDataEntry(value: self.foodAndDrinks, label: "Food And Drinks"))
                            self.entries.append(PieChartDataEntry(value: self.housing, label: "Housing"))
                            self.entries.append(PieChartDataEntry(value: self.transportation, label: "Transportation"))
                            self.entries.append(PieChartDataEntry(value: self.vehicle, label: "Vehicle"))
                            self.entries.append(PieChartDataEntry(value: self.lifeAndEntertainment, label: "Life And Entertainment"))
                            self.entries.append(PieChartDataEntry(value: self.communicationAndPC, label: "Communication"))
                            self.entries.append(PieChartDataEntry(value: self.investment, label: "Investment"))
                            
                            let dataSet = PieChartDataSet(entries: self.entries, label: "")
                            self.pieChartView.data = PieChartData(dataSet: dataSet)
                            self.pieChartView.centerText = "$ \(self.totalExpense)"
                            dataSet.colors = [NSUIColor(hex: 0xFF0000),
                                              NSUIColor(hex: 0xFF7200),
                                              NSUIColor(hex: 0xFFAE00),
                                              NSUIColor(hex: 0xFFEC00),
                                              NSUIColor(hex: 0x2CCB75),
                                              NSUIColor(hex: 0x5FB7D4),
                                              NSUIColor(hex: 0x007ED6),
                                              NSUIColor(hex: 0x8E6BEF),
                                              NSUIColor(hex: 0x9C46D0),
                                              NSUIColor(hex: 0xE01D84)]
                            dataSet.drawValuesEnabled = false
                            self.tableview.reloadData()
                        }
                    }
                }
        }
    }
}

extension StatisticViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "statisticTableViewCell", for: indexPath) as! statisticTableViewCell
        cell.configCell(category: categoryList[indexPath.row])
        return cell
    }


}
