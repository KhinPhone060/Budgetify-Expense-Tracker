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
    
    let db = Firestore.firestore()
    
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
                        let dataSet = PieChartDataSet(entries: self.entries, label: "")
                        self.pieChartView.data = PieChartData(dataSet: dataSet)
                        self.pieChartView.centerText = "No Chart Data"
                    } else {
                        self.entries = []
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                let expense = Double(data["amount"] as! String)
                                let type = data["type"] as! String
                                let category = data["category"] as! String
                                
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
                            self.pieChartView.centerText = ""
                            dataSet.colors = [NSUIColor(hex: 0xFDA97A),NSUIColor(hex: 0xFDEB7A),NSUIColor(hex: 0xCEFD7A),NSUIColor(hex: 0x8DFD7A),NSUIColor(hex: 0x7AFDA9),NSUIColor(hex: 0x7AFDEB),NSUIColor(hex: 0x7A7DFD),NSUIColor(hex: 0x7ABEFD),NSUIColor(hex: 0xFD7AC0),NSUIColor(hex: 0x4968D9)]
                            dataSet.drawValuesEnabled = false
                        }
                    }
                }
        }
    }
}
