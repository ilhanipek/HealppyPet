//
//  CreatedAppointmentsViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 12.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore


class CreatedAppointmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDateStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = sortedDateStringArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDate = sortedDateStringArray[indexPath.row]
        performSegue(withIdentifier: "ToAppointmentTime", sender: selectedDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAppointmentTime" {
            if let selectedDate = sender as? String,
               let destinationVC = segue.destination as? CreatedAppointmentsTimeViewController {
                destinationVC.chosenDate = selectedDate
                
            }
            
            
        }
    }
    
    @IBOutlet weak var createdAppointmentsLabel: UILabel!
    @IBOutlet weak var createdAppointmentTableView: UITableView!
    var email = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    var sortedDateStringArray = [String]()
    var sortedDates = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(sortedDateStringArray)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortedDateStringArray.removeAll()
        sortedDates.removeAll()
        createdAppointmentTableView.reloadData()
        getDataFromFireStore()
        createdAppointmentTableView.delegate = self
        createdAppointmentTableView.dataSource = self
    }
    
    
    func getDataFromFireStore(){
        
        let collectionRef = db.collection("Vet Email Collection")
        let documentRef = collectionRef.document(email!)
        let subcollectionRef = documentRef.collection("Appointment Times")
                
                subcollectionRef.getDocuments { [weak self] (querySnapshot, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    }
                    
                    var datesArray = [String]()
                    
                    for document in querySnapshot!.documents {
                        let documentName = document.documentID
                        datesArray.append(documentName)
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMM yyyy"
                    
                    for dateString in datesArray {
                        if let date = dateFormatter.date(from: dateString) {
                            self.sortedDates.append(date)
                        }
                    }
                    
                    self.sortedDates.sort(by: { $0 < $1 })
                    
                    var sortedDateStringArray = [String]()
                    
                    for date in self.sortedDates {
                        let dateString = dateFormatter.string(from: date)
                        sortedDateStringArray.append(dateString)
                    }
                    
                    self.sortedDateStringArray = sortedDateStringArray
                    DispatchQueue.main.async {
                    self.createdAppointmentTableView.reloadData()
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
    

