//
//  ProfileViewController.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 19.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var CALabel: UILabel!
    @IBOutlet weak var MALabel: UILabel!
    @IBOutlet weak var vetImageView: UIImageView!
    
    let email = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CALabel.isUserInteractionEnabled = true
        let CAlabelGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(CALabelSegue))
        CALabel.addGestureRecognizer(CAlabelGestureRecogniser)
        
        
        vetImageView.isUserInteractionEnabled = true
        let imageViewGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        vetImageView.addGestureRecognizer(imageViewGestureRecogniser)
        
        getImageFromFireStore()
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        performSegue(withIdentifier: "ToFirst", sender: nil)
    }
    
    
    @objc func selectImage(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        vetImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let vetMediaFolder = storageReference.child("VetMedia")
        
        if let data = vetImageView.image?.jpegData(compressionQuality: 0.5){
            
            let imageReference = vetMediaFolder.child("\(email!).jpg")
            
            imageReference.putData(data,metadata: nil) { metaData, error in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error.debugDescription)
                } else {
                    
                    imageReference.putData(data, metadata: nil) { metadata, error in
                        if let error = error {
                            self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                        } else {
                            imageReference.downloadURL { url, error in
                                if let error = error {
                                    self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                                } else if let downloadURL = url?.absoluteString {
                                    let db = Firestore.firestore()
                                    let dbRef = db.collection("Vet Email Collection").document(self.email!)
                                    let documentData: [String: Any] = ["imageUrl": downloadURL]
                                    
                                    dbRef.updateData(documentData) { error in
                                        if let error = error {
                                            self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
                                        } else {
                                            print("Document data added successfully")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getImageFromFireStore(){
        
        let db = Firestore.firestore()
            let dbRef = db.collection("Vet Email Collection").document(self.email!)
            
            dbRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let imageUrl = document.data()?["imageUrl"] as? String {
                        self.vetImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                    }
                } else {
                    print("Document does not exist")
                }
            }
    }
    
    
    @objc func CALabelSegue() {
        
        performSegue(withIdentifier: "ToCreatedAppointments", sender: nil)
    }
    @objc func MALabelSegue(){
        
        performSegue(withIdentifier: "ToMyAppointmentTimes", sender: nil)
    }

    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

   

}
