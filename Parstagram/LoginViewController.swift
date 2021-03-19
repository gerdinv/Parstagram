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
    }

    @IBAction func onLogin(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        PFUser.logInWithUsername(inBackground: username!, password: password!) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            // Do stuff after successful login.
          } else {
            print("Error: \(String(describing: error?.localizedDescription))")
            // The login failed. Check error to see why.
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
