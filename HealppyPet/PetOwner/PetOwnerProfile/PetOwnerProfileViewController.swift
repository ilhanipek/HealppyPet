//
//  PetOwnerProfileViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 21.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class PetOwnerProfileViewController: UIViewController {
    
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var appointmentTimeLabel: UILabel!
    
    let email = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFirestore()
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        performSegue(withIdentifier: "ToFirst", sender: nil)
    }
    func getDataFromFirestore(){
        
        let dbRef = db.collection("pet Email Collection").document(email!).collection("Times")

            dbRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }

                if let document = documents.first {
                    let time = document.get("Time") as? String
                    let date = document.get("Date") as? String
                    
                    DispatchQueue.main.async {
                        self.appointmentTimeLabel.text = time
                        self.appointmentDateLabel.text = date
                    }
                }
            }
        
        
        
        
    }
    
}
