import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var butonSituation : Bool?
    var email : String?
    var password : String?
    
    let vetCollection = "Vet Email Collection"
    let petOwnerCollection = "pet Email Collection"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    @IBAction func signInClicked(_ sender: Any) {

        signInVeterinaryClicked()
    }
    
    func signInVeterinaryClicked(){
        if userNameTextField.text?.isEmpty != nil && passwordTextField.text?.isEmpty != nil {
            
            email = userNameTextField.text
            password = passwordTextField.text
            
            if self.email!.contains("@veterinary"){
                Auth.auth().signIn(withEmail: email!, password: password!) { [self] authResult, error in
                    if let error = error {
                        self.makeAlert(titleInput: "Alert", messageInput: error.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "ToVet", sender: nil)
                    }
                }
            }else if self.email!.contains("@petowner"){
                Auth.auth().signIn(withEmail: email!, password: password!) { [self] authResult, error in
                    if let error = error {
                        self.makeAlert(titleInput: "Alert", messageInput: error.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "ToAFVC", sender: nil)
                    }
                }
            } else {
                
                self.makeAlert(titleInput: "Uygunsuz email", messageInput: "@veterinary ya da @petowner ile giriş yapmanız gerekmektedir")
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Email veya şifre boş olamaz")
        }
        
    }
    func signInPetOwnerClicked(){
        if userNameTextField.text?.isEmpty != nil && passwordTextField.text?.isEmpty != nil {
            
            email = userNameTextField.text
            password = passwordTextField.text
            
            if self.email!.contains("@petowner"){
                Auth.auth().signIn(withEmail: email!, password: password!) { [self] authResult, error in
                    if let error = error {
                        self.makeAlert(titleInput: "Alert", messageInput: error.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: "ToAFVC", sender: nil)
                    }
                }
            }else {
                self.makeAlert(titleInput: "Uygunsuz email", messageInput: "@veterinary ya da @petowner ile giriş yapmanız gerekmektedir")
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Email veya şifre boş olamaz")
        }
    }
    
    
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
