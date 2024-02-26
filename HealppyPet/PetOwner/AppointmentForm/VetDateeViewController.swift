//
//  VetTimeeViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 21.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class VetDateeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vetTimeVetNameLabel: UILabel!
    @IBOutlet weak var vetDatesTableView: UITableView!
    
    var selectedVetName = ""
    var selectedVetMail : String?
    
    
    let db = Firestore.firestore()
    var sortedDateStringArray = [String]()
    var sortedDates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vetTimeVetNameLabel.text = selectedVetName
        
        
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
        vetDatesTableView.reloadData()
        getDataFromFireStore()
        vetDatesTableView.delegate = self
        vetDatesTableView.dataSource = self
    }
    
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
    func getDataFromFireStore(){
        
        let collectionRef = db.collection("Vet Email Collection")
        let documentRef = collectionRef.document(selectedVetMail!)
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
                    self.vetDatesTableView.reloadData()
                    }
                }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDate = sortedDateStringArray[indexPath.row]
        performSegue(withIdentifier: "ToPetOwnerTabBar", sender: selectedDate)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToPetOwnerTabBar"{
            if let selectedDate = sender as? String{
                let destination = segue.destination as! PetOwnerTabBarViewController
                destination.selectedDate = selectedDate
                destination.selectedVetMail = selectedVetName
                destination.silentEmail = selectedVetMail
                
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
