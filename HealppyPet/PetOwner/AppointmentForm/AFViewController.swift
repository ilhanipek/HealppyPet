//
//  AFViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 19.04.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AFViewController: UIViewController {
    
    @IBOutlet weak var petOwnerEmail: UITextField!
    @IBOutlet weak var petNameText: UITextField!
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var howIsPetText: UITextField!
    @IBOutlet weak var messageFoeVetText: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var toVetButton: UIButton!
    
    
    var selectedVetName = "Vet Name"
    var chosenDate = "Date"
    var chosenTime = "Time"
    var chosenSilentEmail : String?
    var date = ""
    var time = ""
    
    let db = Firestore.firestore()
    let getNameInstance = GetName()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateLabelGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(dateLabelClicked))
        dateLabel.addGestureRecognizer(dateLabelGestureRecogniser)
        
        let timeLabelGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(timeLabelClicked))
        timeLabel.addGestureRecognizer(timeLabelGestureRecogniser)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        print(chosenSilentEmail)
            if let email = Auth.auth().currentUser?.email {
                if selectedVetName == "Vet Name" {
                    dateLabel.isUserInteractionEnabled = false
                } else {
                    dateLabel.isUserInteractionEnabled = true
                }
                
                if dateLabel.isUserInteractionEnabled == false {
                    dateLabel.textColor = .opaqueSeparator
                    timeLabel.isUserInteractionEnabled = false
                } else {
                    dateLabel.textColor = .black
                    if chosenDate != "Date" {
                        timeLabel.isUserInteractionEnabled = true
                    } else {
                        timeLabel.isUserInteractionEnabled = false
                    }
                }
                
                if timeLabel.isUserInteractionEnabled == false {
                    timeLabel.textColor = .opaqueSeparator
                } else {
                    timeLabel.textColor = .black
                }
                
                vetLabel.text = selectedVetName
                vetLabel.textAlignment = .center
                dateLabel.text = chosenDate
                
                getNameInstance.fetchName(fieldName: "Pet Owner Name", collectionName: "pet Email Collection", documentName: email) { [weak self] name in
                    DispatchQueue.main.async {
                        self?.petOwnerEmail.text = name
                        self?.petOwnerEmail.textAlignment = .center
                    }
                }
                print(email)
                
                timeLabel.text = chosenTime
                emailTextField.text = email
                
            } else {
                print("E-posta değeri alınamadı.")
                // E-posta değeri alınamadığı durumda gerekli işlemler yapılabilir
            }
        
    }
    
    @objc func timeLabelClicked(){
        
        performSegue(withIdentifier: "ToVetTime2", sender: nil)
    }
 
    
    @objc func dateLabelClicked(){
        
        performSegue(withIdentifier: "ToVetTime", sender: nil)
        
    }
    
    
    
    
    @IBAction func toVetButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "ToVetVC", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToVetTime" {
            
            let destination = segue.destination as? VetDateeViewController
            destination?.selectedVetName = selectedVetName
            destination?.selectedVetMail = chosenSilentEmail
            
        }
        if segue.identifier == "ToVetTime2"{
            
            let destination = segue.destination as? VetTimeeViewController
            destination?.selectedVetName = selectedVetName
            destination?.selectedDate = chosenDate
            destination?.selectedVetMail2 = chosenSilentEmail
            
            
        }
        
    }
    
    @IBAction func sendFormButtonClicked(_ sender: Any) {
        
        let email = Auth.auth().currentUser?.email
        date = dateLabel.text!
        time = timeLabel.text!
        
        if petOwnerEmail.text?.isEmpty != nil && petNameText.text != "" &&
           vetLabel.text != "Vet Name" &&
           howIsPetText.text != "" &&
           messageFoeVetText.text != "" &&
           dateLabel.text != "Date" &&
           timeLabel.text != "Time" &&
            emailTextField.text != ""
        {
            db.collection("Vet Email Collection").document(chosenSilentEmail!).collection("Appointment Times").document(date).collection("Times").document(time).getDocument { [self] (document, error) in
                
                if let document = document, document.exists {
                    self.makeAlert(titleInput: "Warning!", messageInput: "This date is taken")
                } else{
                    let dataDict : [String: Any] = ["Pet Owner Name" : self.petOwnerEmail.text,"Pet Name" : self.petNameText.text,"How Is Pet" : self.howIsPetText.text,"Message To Vet": self.messageFoeVetText.text, "Date" : self.chosenDate,"Time" : self.chosenTime, "Pet Owner Email" : self.emailTextField.text]
                    let dbRef : DocumentReference?
                    dbRef = db.collection("Vet Email Collection").document(chosenSilentEmail!).collection("Appointment Times").document(chosenDate)
                    dbRef!.collection("Times").document(self.chosenTime).setData(dataDict)
                    self.makeAlert(titleInput: "Kayıt İşlemi", messageInput: "Başarılı")
                    
                    let dataDict2 : [String: Any] = ["Date": chosenDate ,"Time" : chosenTime]
                    let dbRef2 = db.collection("pet Email Collection").document(email!)
                    dbRef2.collection("Times").document(chosenTime).setData(dataDict2)
                }
                    
                }
            }else {
                makeAlert(titleInput: "Fail", messageInput: "Form fields can not be empty")
                
            }
            
        
    }
    
    func makeAlert(titleInput : String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
