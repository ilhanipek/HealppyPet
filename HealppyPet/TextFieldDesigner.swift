//
//  TextFieldDesigner.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 12.06.2023.
//

import Foundation
import UIKit

struct Designer {
    
    
    mutating func designTextfield(textfield: UITextField, radius : Int){
        
        textfield.layer.cornerRadius = CGFloat(radius)
        
    }
    
    mutating func designButton(button: UIButton, radius : Int){
        
        button.layer.cornerRadius = CGFloat(radius)
    }
}
