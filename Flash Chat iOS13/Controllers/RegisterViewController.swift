
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import ProgressHUD



class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text ,let password = passwordTextfield.text{
        Auth.auth().createUser( withEmail: email, password: password) {(authResult,error) in
            
            if let e = error {
                print(e)
                ProgressHUD.showError(e.localizedDescription)
            } else {
                self.performSegue(withIdentifier: C.registerSegue, sender: self)
            }
            
            
    }
    }
}
}
