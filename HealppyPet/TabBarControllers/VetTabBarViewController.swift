//
//  VetTabBarViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 10.05.2023.
//

import UIKit

class VetTabBarViewController: UITabBarController {

    var vetEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        
        
        guard let viewControllers = viewControllers else{return }
        
        
        for viewcontroller in viewControllers{
            
            if let settingsViewController = viewcontroller as? SettingsViewController{
                
                settingsViewController.enteredVet = vetEmail
                
            }
               
            
                
        }
    }
 



}
