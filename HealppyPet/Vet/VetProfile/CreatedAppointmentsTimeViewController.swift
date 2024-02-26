//
//  CreatedAppointmentsTimeViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 16.05.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CreatedAppointmentsTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var chosenDate: String?
    var timeArray: [String] = []
    var email = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chosenDate)
        
        
    }
    
    func getDataFromFirestore(){
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("Vet Email Collection").document(email!).collection("Appointment Times")
        let documentRef = collectionRef.document(chosenDate!)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let times = data["times"] as? [[String: Any]] {
                    self.timeArray = times.compactMap { $0["time"] as? String }
                    print("Times: \(self.timeArray)")
                } else {
                    print("Saat verileri bulunamadı.")
                }
            } else {
                print("Belge bulunamadı veya bir hata oluştu.")
            }
            
            DispatchQueue.main.async {
                self.timeTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            if let chosenDate = chosenDate {
                dateLabel.text = chosenDate
                timeTableView.delegate = self
                timeTableView.dataSource = self

                getDataFromFirestore()
            } else {
                print("chosenDate değeri nil.")
            }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        print(timeArray)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTime = timeArray[indexPath.row]
        performSegue(withIdentifier: "ToFormData", sender: selectedTime)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFormData" {
            if let selectedTime = sender as? String,
               let destination = segue.destination as? FormDataViewController {
                destination.selectedTime = selectedTime
                destination.selectedDate = chosenDate
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = timeArray[indexPath.row]
        return cell
    }
}
