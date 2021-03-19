//
//  SignUpViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        let imageData = UIImage(named: "profile_tab")!.pngData() //Default profile picture 
        
        user.email = emailTextField.text
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user["fullname"] = fullnameTextField.text
        user["profileImage"] = PFFileObject(data: imageData!)!
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegueFromSignUp", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
