//
//  VetViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 20.04.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

class VetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vetTableView: UITableView!
    var vetNameArray = [String]()
    var vetImageArray = [String]()
    var vetExperyArray = [String]()
    var vetEmailArray = [String]()
    var vetPhoneNumberArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vetTableView.delegate = self
        vetTableView.dataSource = self
        getDataFromFireStore()
        
    }
    
    func getDataFromFireStore(){
        
        let fireStore = Firestore.firestore()
        
        fireStore.collection("Vet Email Collection").addSnapshotListener { snapshot, error in
            
            if error != nil {
                
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
            } else {
                
                if snapshot?.isEmpty != true {
                        
                    
                    for document in snapshot!.documents {
                        
                        if let vetName = document.get("Vet Name") as? String {
                            
                            self.vetNameArray.append(vetName)
                        }
                        if let vetImage = document.get("imageUrl") as? String{
                            
                            self.vetImageArray.append(vetImage)
                        }
                        if let vetExperty = document.get("Experty") as? String{
                            
                            self.vetExperyArray.append(vetExperty)
                        }
                        if let vetEmail = document.get("email") as? String{
                            
                            self.vetEmailArray.append(vetEmail)
                        }
                        if let vetPhoneNumber = document.get("Phone Number") as? String{
                            
                            self.vetPhoneNumberArray.append(vetPhoneNumber)
                        }
                    }
                }
            }
            self.vetTableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vetNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VetCell
        cell.vetImageView.sd_setImage(with: URL(string: self.vetImageArray[indexPath.row]))
        cell.vetNameLael.text = vetNameArray[indexPath.row]
        cell.expertyLabel.text = vetExperyArray[indexPath.row]
        cell.emailLabel.text = vetEmailArray[indexPath.row]
        cell.phoneNumberLabel.text = vetPhoneNumberArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! VetCell
            performSegue(withIdentifier: "ToPetOwnerTabBar", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPetOwnerTabBar" {
            
            let destination = segue.destination as! PetOwnerTabBarViewController
            if let cell = sender as? VetCell {
                
                let indexpath = vetTableView.indexPath(for: cell)
                let vetName = vetNameArray[indexpath!.row]
                let vetMail = vetEmailArray[indexpath!.row]
                destination.selectedVetMail = vetName
                destination.silentEmail = vetMail
                
                
            } else {
                print("error")
                print(vetNameArray)
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
