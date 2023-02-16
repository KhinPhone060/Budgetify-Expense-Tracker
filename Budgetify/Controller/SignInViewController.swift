//
//  SignInViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 16/02/2023.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.layer.borderWidth = 0.2
        emailTextField.layer.cornerRadius = 7
        
        passwordTextField.layer.borderWidth = 0.2
        passwordTextField.layer.cornerRadius = 7
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        
    }
}
