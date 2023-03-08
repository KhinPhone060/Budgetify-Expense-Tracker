//
//  ProfileViewController.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 23/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser?.email
    
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
        db.collection("user")
            .whereField("user", isEqualTo: currentUser!)
            .getDocuments() { querySnapshot, err in
                if let e = err {
                    print("There was problem retrieving data from the firestore \(e)")
                } else if querySnapshot?.documents.count == 0 {
                    print("no user")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let userName = data["userName"] as? String
                            let email = data["user"] as? String
                            
                            DispatchQueue.main.async {
                                self.userNameLabel.text = userName!
                                self.emailLabel.text = email!
                            }
                            
                        }
                    }
                }
            }
    }
}
