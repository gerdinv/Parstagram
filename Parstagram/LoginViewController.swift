//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func onLogin(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        PFUser.logInWithUsername(inBackground: username!, password: password!) {
          (user, error) in
          if user != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
          } else {
//          Wrong crendentials alert
            let alert = UIAlertController(title: "Wrong Credentials", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
          }
        }
    }
    
    
    @IBAction func onResetPassword(_ sender: Any) {
//        let email = usernameTextField.text as! String
//        PFUser.requestPasswordResetForEmail(inBackground: email)
//        print("password reset")
    }
}
