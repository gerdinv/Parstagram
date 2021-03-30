//
//  ResetViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/30/21.
//

import UIKit
import Parse

class ResetViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onReset(_ sender: Any) {
        let email = emailTextField.text!
        
//      Sends the email
        PFUser.requestPasswordResetForEmail(inBackground: email)
        
//      Request processed alert
        let alert = UIAlertController(title: "Password Reset", message: "An email was sent providing password reset instructions. If you did not receive an email, your email is not in our database and you can create an account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
}
