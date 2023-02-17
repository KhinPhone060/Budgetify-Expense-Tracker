//
//  WalletViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 17/02/2023.
//

import UIKit
import Charts

class WalletViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPieChart()
    }

    func setUpPieChart() {
        pieChartView.chartDescription.enabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.isUserInteractionEnabled = false
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: 50.0, label: "Bill"))
        entries.append(PieChartDataEntry(value: 30.0, label: "Meal"))
        entries.append(PieChartDataEntry(value: 20.0, label: "Grocery"))
        entries.append(PieChartDataEntry(value: 10.0, label: "Snacks"))
        entries.append(PieChartDataEntry(value: 40.0, label: "Personal"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let c1 = NSUIColor(hex: 0x3A015C)
        let c2 = NSUIColor(hex: 0x4F0147)
        let c3 = NSUIColor(hex: 0x35012C)
        let c4 = NSUIColor(hex: 0x290025)
        let c5 = NSUIColor(hex: 0x11001C)
        
        dataSet.colors = [c1, c2, c3, c4, c5]
        dataSet.drawValuesEnabled = false
        
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
}
