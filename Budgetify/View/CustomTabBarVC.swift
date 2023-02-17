//
//  CustomTabBarVC.swift
//  Budgetify
//
//  Created by Khin Phone Ei on 11/02/2023.
//

import Foundation
import UIKit

class CustomTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.delegate = self
            self.selectedIndex = 0
            setupMiddleButton()
        }
        
        func setupMiddleButton() {
            let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 60, y: -30, width: 120, height: 120))
            
            middleButton.setBackgroundImage(UIImage(named: "Group 10"), for: .normal)
            middleButton.layer.shadowColor = UIColor.black.cgColor
            middleButton.layer.shadowOpacity = 0.1
            middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            
            self.tabBar.addSubview(middleButton)
            middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
            
            self.view.layoutIfNeeded()
        }
        
        @objc func menuButtonAction(sender: UIButton) {
            self.selectedIndex = 2
        }
}
