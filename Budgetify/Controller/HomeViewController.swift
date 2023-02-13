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
    
    var transactionList = [Transaction]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletCardView.layer.cornerRadius = 20
        walletCardView.layer.shadowColor = UIColor.black.cgColor
        walletCardView.layer.shadowOpacity = 0.1
        walletCardView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadTransactionList()
        
        //register cell
        let cellNib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        transactionTableView.register(cellNib, forCellReuseIdentifier: "TransactionTableViewCell")
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
    func loadTransactionList(with request: NSFetchRequest<Transaction> = Transaction.fetchRequest()) {
        do {
            transactionList = try context.fetch(request)
        } catch {
            print("Error in loading list \(error)")
        }
        transactionTableView.reloadData()
    }
}

