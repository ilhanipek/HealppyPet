//
//  FirstViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 23.05.2023.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.backgroundColor = .systemIndigo
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.tintColor = .secondarySystemGroupedBackground
    }
    


    @IBAction func createAccountButtonClicked(_ sender: Any) {
        
       performSegue(withIdentifier: "ToSignUp", sender: nil)
    }
    
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "ToSignIn", sender: nil)
        
    }
}
