//
//  FormDataViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 23.05.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FormDataViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var petOwnerNameTextField: UITextField!
    @IBOutlet weak var petOwnerEmailTextField: UITextField!
    @IBOutlet weak var petNameTextField: UITextField!
    @IBOutlet weak var howIsPetTextField: UITextView!
    @IBOutlet weak var messageTextField: UITextView!
    
    var selectedTime : String?
    var selectedDate : String?
    let email = Auth.auth().currentUser?.email
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromFireStore()
        timeTextField.text = selectedTime
        dateTextField.text = selectedDate
    }
    
    func getDataFromFireStore(){
        
        let firestore = Firestore.firestore()

        firestore.collection("Vet Email Collection").document(email!).collection("Appointment Times").document(selectedDate!).collection("Times").document(selectedTime!).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let petOwnerName = document.get("Pet Owner Name") as? String {
                        DispatchQueue.main.async {
                            self.petOwnerNameTextField.text = petOwnerName
                        }
                    }
                    if let petOwnerEmail = document.get("Pet Owner Email") as? String {
                        DispatchQueue.main.async {
                            self.petOwnerEmailTextField.text = petOwnerEmail
                        }
                    }
                    if let petName = document.get("Pet Name") as? String {
                        DispatchQueue.main.async {
                            self.petNameTextField.text = petName
                        }
                    }
                    if let howIsPet = document.get("How Is Pet") as? String {
                        DispatchQueue.main.async {
                            self.howIsPetTextField.text = howIsPet
                        }
                    }
                    if let messageToVet = document.get("Message To Vet") as? String {
                        DispatchQueue.main.async {
                            self.messageTextField.text = messageToVet
                        }
                    }
                    
                    
                } else {
                    self.makeAlert(titleInput: "Bilgi", messageInput: "Randevu Bulunamadı")
                }
            }
            
            
            
        }
        
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
        
    }

