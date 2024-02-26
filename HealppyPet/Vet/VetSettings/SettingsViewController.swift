//
//  SettingsViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 22.04.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var appointmentDateText: UITextField!
    @IBOutlet weak var vetNameText: UITextField!
    @IBOutlet weak var clickButton: UIButton!
    
    var datepicker = UIDatePicker()
    var enteredVet = ""
    
    var email = Auth.auth().currentUser?.email
    let getNameInstance = GetName()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createDatePicker()
        
        let hideKeyboardGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(hideKeyboardGestureRecogniser)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNameInstance.fetchName(fieldName: "Vet Name", collectionName: "Vet Email Collection", documentName: email!) { [weak self] name in
            self?.vetNameText.text = name
        }
        
        
    }
    
    @objc func clickButtonn(){
        
        
    }
    
    
    func createDatePicker(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        
        let barDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(doneClicked))
        toolBar.setItems([barDoneButton], animated: true)
        
        appointmentDateText.inputAccessoryView = toolBar
        
        appointmentDateText.inputView = datepicker
        
        datepicker.datePickerMode = .date
    }
    @objc func doneClicked(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        appointmentDateText.text = formatter.string(from: datepicker.date)
        self.view.endEditing(true)
        
        
    }
    
    
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardDismiss(){
        
        self.view.endEditing(true)
    }
    
    @IBAction func clickButton(_ sender: Any) {
        performSegue(withIdentifier: "ToTimeView", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToTimeView"{
            let destination = segue.destination as! TimeViewController
            destination.chosenDate = appointmentDateText.text
            destination.timeVetEmail = vetNameText.text
            
        }
   
        }
        
    }

