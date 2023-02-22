//
//  StatisticViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 17/02/2023.
//

import UIKit
import Charts

class WalletViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    var numbers : [Double] = [0.0,2.3,8.1,1.5,5.0]
    let xLabels: [String] = ["Mon","Tue","Wed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<numbers.count {

                    let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
                    lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Expense") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.black]
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        line1.lineWidth = 3
        line1.fill = ColorFill(color: .black)
        line1.fillAlpha = CGFloat(0.1)
        line1.drawFilledEnabled = true

        let data = LineChartData() //This is the object that will be added to the chart
        data.append(line1) //Adds the line to the dataSet
                
        lineChartView.data = data //finally - it adds the chart data to the chart and causes an update
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 0.5)
//        lineChartView.xAxis.labelPosition = .bottom
//        lineChartView.xAxis.drawGridLinesEnabled = false
    }

}
