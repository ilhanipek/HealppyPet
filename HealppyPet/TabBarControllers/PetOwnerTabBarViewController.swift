//
//  PetOwnerTabBarViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 22.05.2023.
//

import UIKit


class PetOwnerTabBarViewController: UITabBarController {

    var selectedVetMail : String?
    var selectedDate : String?
    var selectedTime : String?
    var silentEmail : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        guard let viewControllers = viewControllers else{ return }
        
        
        for viewcontroller in viewControllers{
            
            if let AFViewController = viewcontroller as? AFViewController{
                
                AFViewController.selectedVetName = selectedVetMail ?? "Vet Name"
                AFViewController.chosenDate = selectedDate ?? "Date"
                AFViewController.chosenTime = selectedTime ?? "Time"
                AFViewController.chosenSilentEmail = silentEmail
                
                
                
            }
               
            
                
        }
    }
    

}
