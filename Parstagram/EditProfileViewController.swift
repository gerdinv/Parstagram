//
//  EditProfileViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/27/21.
//

import UIKit
import Parse
import AlamofireImage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()
        
//      Getting image
        let imageFile = user!["profileImage"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
        profileImage.af.setImage(withURL: imageUrl!)
        
        descriptionTextView.text = user!["description"] as! String
        
        self.descriptionTextView!.layer.borderWidth = 2
        self.descriptionTextView.layer.cornerRadius = 10
        self.descriptionTextView.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha: 1).cgColor
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func onImageClick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//      Resize the Image
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let imageScaled = image.af.imageAspectScaled(toFill: size)
                
        profileImage.image = imageScaled
                
        dismiss(animated: true, completion: nil) //Dismiss the camera view
    }
    
    @IBAction func onSave(_ sender: Any) {
        let user = PFUser.current()
        
        
        let imageData = profileImage.image!.pngData()
        let imageFile = PFFileObject(data: imageData!)
        

        user!["profileImage"] = imageFile
        
        if descriptionTextView.text != "" {
            user!["description"] = descriptionTextView.text
        }
        
        
        user!.saveInBackground { (success, error) in
            if success {
                let alert = UIAlertController(title: "Updated Profile Successfully!", message: "Your profile has now been updated.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Saved")
            } else {
                let alert = UIAlertController(title: "Error updating profile", message: "There was an error updating your profile. Please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("ERROR! \(String(describing: error))")
            }
        }
    }
}
