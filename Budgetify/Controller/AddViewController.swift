//
//  AddViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 12/02/2023.
//

import UIKit
import iOSDropDown
import FirebaseFirestore
import UITextField_Shake
import FirebaseAuth

class AddViewController: UIViewController {
    
    @IBOutlet weak var typeDropdown: DropDown!
    @IBOutlet weak var categoryDropdown: DropDown!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    var transaction = [Transaction]()
    
    let db = Firestore.firestore()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeDropdown.optionArray = ["Expense","Income"]
        categoryDropdown.optionArray = ["Shopping", "Bill", "Tax", "Food & Drinks", "Housing", "Transportation", "Vehicle", "Life & Entertainment", "Communication, PC", "Investment"]
        
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.hideKeyboardWhenTappedAround()
        createDatePicker()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        
        if categoryDropdown.text == "" {
            categoryDropdown.shake(10, withDelta: 5, speed: 0.05)
        } else if amountTextField.text == "" {
            amountTextField.shake(10, withDelta: 5, speed: 0.05)
        } else if descriptionTextField.text == "" {
            descriptionTextField.shake(10, withDelta: 5, speed: 0.05)
        } else if dateTextField.text == "" {
            dateTextField.shake(10, withDelta: 5, speed: 0.05)
        } else {
            
            if let transactionType = typeDropdown.text,
               let category = categoryDropdown.text,
               let amount = amountTextField.text,
               let description = descriptionTextField.text,
               let date = dateTextField.text,
               let user = Auth.auth().currentUser?.email
            {
                db.collection("transaction")
                    .addDocument(data: [
                        Constants.Fstore.user: user,
                        Constants.Fstore.transactionType: transactionType,
                        Constants.Fstore.category: category,
                        Constants.Fstore.amount: amount,
                        Constants.Fstore.description: description,
                        Constants.Fstore.date: date,
                        Constants.Fstore.timeAdded: Date().timeIntervalSince1970
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
    
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)

        return toolbar
    }

    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolBar()
    }

    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
