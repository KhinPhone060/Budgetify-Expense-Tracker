//
//  AddViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 12/02/2023.
//

import UIKit
import iOSDropDown

class AddViewController: UIViewController {
    
    @IBOutlet weak var typeDropdown: DropDown!
    @IBOutlet weak var categoryDropdown: DropDown!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var transaction = [Transaction]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeDropdown.optionArray = ["Expense","Income"]
        categoryDropdown.optionArray = ["Shopping", "Bill", "Tax", "Food & Drinks", "Housing", "Transportation", "Vehicle", "Life & Entertainment", "Communication, PC", "Investment"]
        
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 4, height: 4)

        //self.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        let newTransaction = Transaction(context: context)
        newTransaction.type = typeDropdown.text
        newTransaction.category = categoryDropdown.text!
        newTransaction.amount = amountTextField.text!
        newTransaction.transactionDescription = descriptionTextField.text!
        self.saveTransaction()
    }
    
    func saveTransaction() {
        do{
            try context.save()
            print("Success")
        } catch {
            print("Error in saving context \(error)")
        }
    }
}
