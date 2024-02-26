//
//  VetSignUpViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 23.05.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class VetSignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var vetNameTextField: UITextField!
    @IBOutlet weak var expertyTextField: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    var email : String?
    var password : String?
    var vetName : String?
    var experty : String?
    var phoneNumber : String?
    
    
    let db = Firestore.firestore()
    let vetCollection = "Vet Email Collection"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func createVetUserButtonClicked(_ sender: Any) {
        
        if emailTextField.text?.isEmpty != nil && passwordTextfield.text?.isEmpty != nil && vetNameTextField.text?.isEmpty != nil && expertyTextField.text?.isEmpty != nil && phoneNumberTextfield.text?.isEmpty != nil{
            
            email = emailTextField.text
            password = passwordTextfield.text
            vetName = vetNameTextField.text
            experty = expertyTextField.text
            phoneNumber = phoneNumberTextfield.text
            
            
            if self.email!.contains("@veterinary"){
                Auth.auth().createUser(withEmail: email!, password: password!) { [self] authResult, error in
                    if let error = error {
                        self.makeAlert(titleInput: "Alert", messageInput: error.localizedDescription)
                    } else {
                        let dbRef = Firestore.firestore().collection(vetCollection)
                        let userRef = dbRef.document(email!)
                        let data = ["email" : email,"Vet Name": vetName,"Experty": experty,"Phone Number": phoneNumber]
                        userRef.setData(data)
                        makeAlert(titleInput: "Kullanıcı Kaydı", messageInput: "Başarılı")
                        
                    }
                }
            } else{
                makeAlert(titleInput: "Hata!", messageInput: "@veterinary ile kayıt olunuz veya email kısmının boş olmadığından emin olunuz")
            }
        } else{
            makeAlert(titleInput: "Hata!", messageInput: "Kayıt bilgilerinde boş hücre var")
        }
        performSegue(withIdentifier: "ToLogIn", sender: nil)
    }
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }


}
