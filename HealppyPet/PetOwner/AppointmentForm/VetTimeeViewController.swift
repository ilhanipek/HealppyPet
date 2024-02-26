//
//  VetTimeeViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 23.05.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class VetTimeeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var vetNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTimeTableView: UITableView!
    
    var selectedVetName : String?
    var selectedVetMail2 : String?
    var selectedDate : String?
    var timeArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {

        vetNameLabel.text = selectedVetName
        dateLabel.text = selectedDate
        dateTimeTableView.delegate = self
        dateTimeTableView.dataSource = self
        getDataFromFirestore()
        
    }
    
    func getDataFromFirestore(){
        print(selectedVetMail2)
        let db = Firestore.firestore()
        let collectionRef = db.collection("Vet Email Collection").document(selectedVetMail2!).collection("Appointment Times")
        let documentRef = collectionRef.document(selectedDate!)
        
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
                self.dateTimeTableView.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTime = timeArray[indexPath.row]
        performSegue(withIdentifier: "ToPetOwnerTabBar", sender: selectedTime)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPetOwnerTabBar"{
            if let selectedTime = sender as? String{
                let destination = segue.destination as! PetOwnerTabBarViewController
                destination.selectedDate = selectedDate
                destination.selectedTime = selectedTime
                destination.selectedVetMail = selectedVetName
                destination.silentEmail = selectedVetMail2
            }
            
            
            
        }
    }


}
