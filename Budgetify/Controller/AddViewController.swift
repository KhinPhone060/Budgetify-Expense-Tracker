//
//  AddViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 12/02/2023.
//

import UIKit
import iOSDropDown
import FirebaseFirestore
import UITextField_Shake_Swift_

class AddViewController: UIViewController {
    
    @IBOutlet weak var typeDropdown: DropDown!
    @IBOutlet weak var categoryDropdown: DropDown!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var transaction = [Transaction]()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeDropdown.optionArray = ["Expense","Income"]
        categoryDropdown.optionArray = ["Shopping", "Bill", "Tax", "Food & Drinks", "Housing", "Transportation", "Vehicle", "Life & Entertainment", "Communication, PC", "Investment"]
        
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        
        if categoryDropdown.text == "" {
            categoryDropdown.shake(times: 10, delta: 5, speed: 0.05)
        } else if amountTextField.text == "" {
            amountTextField.shake(times: 10, delta: 5, speed: 0.05)
        } else if descriptionTextField.text == "" {
            descriptionTextField.shake(times: 10, delta: 5, speed: 0.05)
        } else {
            
            if let transactionType = typeDropdown.text,
               let category = categoryDropdown.text,
               let amount = amountTextField.text,
               let description = descriptionTextField.text
            {
                db.collection("transaction")
                    .addDocument(data: [
                        Constants.Fstore.transactionType: transactionType,
                        Constants.Fstore.category: category,
                        Constants.Fstore.amount: amount,
                        Constants.Fstore.description: description,
                        Constants.Fstore.date: Date().timeIntervalSince1970
                    ]){ (error) in
                        if let e = error {
                            print("There was an issue saving data to the firestore, \(e)")
                        } else{
                            print("Successfully saved data")
                        }
                    }
            }
            self.navigateBackToHome()
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigateBackToHome()
    }
    
    func navigateBackToHome() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc!)
    }
}
