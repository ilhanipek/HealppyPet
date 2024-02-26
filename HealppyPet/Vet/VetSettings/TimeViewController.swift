//
//  TimeViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 29.04.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class TimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var chosenDate : String?
    var timeVetEmail : String?
    
    let datePicker = UIDatePicker()
    var timeArray: [String] = []
    var timeCount: Int = 0
    
    let db = Firestore.firestore()
    var userRef: DocumentReference?
    
    var timeDictArray: [[String: Any]] = []
    var timeNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTableView.delegate = self
        timeTableView.dataSource = self
        let hideKeyboardGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGestureRecogniser)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        dateLabel.text = chosenDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
                cell.timeTextField.text = timeArray[indexPath.row]
                cell.timeTextField.tag = indexPath.row
                cell.timeTextField.addTarget(self, action: #selector(createTimePicker), for: .editingDidBegin)
                return cell
    }
    
    @objc func createTimePicker(_ sender : UITextField){
        
        let index = sender.tag
        datePicker.tag = index
        let cell = timeTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! TimeCell
        cell.timeTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClicked))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        cell.timeTextField.inputAccessoryView = toolbar
    
    }
    
    @objc func doneButtonClicked(){
        let index = datePicker.tag 
        let cell = timeTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! TimeCell
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "HH:mm"
//        formatter.timeZone = TimeZone(identifier: "UTC")
        cell.timeTextField.text = formatter.string(from: datePicker.date)
        timeArray[index] = cell.timeTextField.text!
        print(timeArray)
        self.view.endEditing(true)
        
    }
        
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    


    }
    
    
    @IBAction func addCellButton(_ sender: Any) {
        timeArray.append("")
        timeCount += 1
        timeTableView.insertRows(at: [IndexPath(row: timeCount - 1, section: 0)], with: .automatic)
    }
    
    @IBAction func addAppointmentTimeButton(_ sender: Any) {
        guard let currentEmail = Auth.auth().currentUser?.email else{ return }
        var sortedTimeArray = timeArray.sorted()
                var timeDictArray: [[String: Any]] = []
                for (index, time) in sortedTimeArray.enumerated() {
                    let timeDict: [String: Any] = ["time": time]
                    timeDictArray.append(timeDict)
                }
                print(timeDictArray)
        db.collection("Vet Email Collection").document(currentEmail).collection("Appointment Times").document(dateLabel.text!).setData(["times": timeDictArray]) { error in
                    if let error = error {
                        self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                    } else {
                        self.makeAlert(titleInput: "Success", messageInput: "Appointment times are saved!")
                    }
                }
        
        
    }
    
    @IBAction func toSettingBackButton(_ sender: Any) {
        performSegue(withIdentifier: "ToVetTab", sender: nil)
        
    }
    
        
    
    
    func makeAlert(titleInput : String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
   
    

