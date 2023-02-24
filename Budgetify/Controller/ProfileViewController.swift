//
//  ProfileViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 23/02/2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
    }
    
    @IBAction func accountInfoPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
                    
            self.navigateToSignUp()
            } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            }
    }
}

extension ProfileViewController {
    func loadUserInfo() {
        if let user = Auth.auth().currentUser {
            self.userNameLabel.text = user.displayName
            self.emailLabel.text = user.email
        }
    }
}
