//
//  GettingName.swift
//  HealppyPet
//
//  Created by ilhan serhan ipek on 24.05.2023.
//

import Foundation

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

public class GetName {
    public var name: String = ""
    let firestore = Firestore.firestore()
    let email = Auth.auth().currentUser?.email


    public init() {}
    
    public func fetchName(fieldName: String,collectionName : String ,documentName: String, completion: @escaping (String) -> Void) {
        firestore.collection(collectionName).document(documentName).getDocument { (document, error) in
            if let document = document, document.exists {
                if let fieldValue = document.get(fieldName) as? String {
                    DispatchQueue.main.async {
                        self.name = fieldValue
                        completion(fieldValue)
                    }
                } else{
                    print("error1")
                }
            }else{
                print("error2")
            }
        }
    }
}
