//
//  SetUpAccountViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 25/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import UITextField_Shake

class SetUpAccountViewController: UIViewController {
    
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UIView!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor(hex: 0xF1F1FA).cgColor
        nameTextField.layer.cornerRadius = 10
        textView.layer.cornerRadius = 30
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if balanceTextField.text == "" {
            balanceTextField.shake(10, withDelta: 5, speed: 0.05)
        } else if nameTextField.text == "" {
            nameTextField.shake(10, withDelta: 5, speed: 0.05)
        } else {
            if let userName = nameTextField.text,
               let balance = balanceTextField.text,
               let email = Auth.auth().currentUser?.email {
                db.collection("user")
                    .addDocument(data: [
                        Constants.Fstore.userName: userName,
                        Constants.Fstore.balance: balance,
                        Constants.Fstore.user: email
                    ]) { (error) in
                        if let e = error {
                            print("There was an issue saving data to the firestore, \(e)")
                        } else{
                            print("Successfully saved data")
                            self.navigateBackToHome()
                        }
                    }
            }
        }
    }
}
