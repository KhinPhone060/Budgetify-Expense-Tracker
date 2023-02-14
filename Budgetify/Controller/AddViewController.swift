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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeDropdown.optionArray = ["Expense","Income"]
        categoryDropdown.optionArray = ["Shopping", "Bill", "Tax", "Food & Drinks", "Housing", "Transportation", "Vehicle", "Life & Entertainment", "Communication, PC", "Investment"]
        
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.saveTransaction()
        self.navigateBackToHome()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigateBackToHome()
    }
    
    func saveTransaction() {
        
    }
    
    func navigateBackToHome() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc!)
    }
}
