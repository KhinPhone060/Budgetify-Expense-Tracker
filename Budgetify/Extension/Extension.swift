//
//  Extension.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 15/02/2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func navigateBackToHome() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc!)
    }
    
    func navigateToSignUp() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "signUpViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc!)
    }
}
