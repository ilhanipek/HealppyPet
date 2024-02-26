//
//  PetOwnerSignUpViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 23.05.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PetOwnerSignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var petownerNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var email : String?
    var password : String?
    var petOwnerName : String?
    var phoneNumber : String?
    
    let db = Firestore.firestore()
    let petOwnerCollection = "pet Email Collection"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func createPetOwnerUserButtonClicked(_ sender: Any) {
        
        if emailTextField.text?.isEmpty != nil && passwordTextField.text?.isEmpty != nil && petownerNameTextfield.text?.isEmpty != nil && petownerNameTextfield.text?.isEmpty != nil && phoneNumberTextField.text?.isEmpty != nil{
            
            email = emailTextField.text
            password = passwordTextField.text
            petOwnerName = petownerNameTextfield.text
            phoneNumber = phoneNumberTextField.text
            
            
            if self.email!.contains("@petowner"){
                Auth.auth().createUser(withEmail: email!, password: password!) { [self] authResult, error in
                    if let error = error {
                        self.makeAlert(titleInput: "Alert", messageInput: error.localizedDescription)
                    } else {
                        let dbRef = Firestore.firestore().collection(petOwnerCollection)
                        let userRef = dbRef.document(email!)
                        let data = ["email" : email,"Pet Owner Name": petOwnerName,"Phone Number": phoneNumber]
                        userRef.setData(data)
                        makeAlert(titleInput: "Kullanıcı Kaydı", messageInput: "Kullanıcı kaydı başarılı sign")
                    }
                }
            } else{
                makeAlert(titleInput: "Hata!", messageInput: "@petowner ile kayıt olunuz veya email kısmının boş olmadığından emin olunuz")
            }
        } else{
            makeAlert(titleInput: "Hata!", messageInput: "Kayıt bilgilerinde boş hücre var")
        }
        performSegue(withIdentifier: "Tologin", sender: nil)
    }
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}
