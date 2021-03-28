////
////  EditProfileViewController.swift
////  Parstagram
////
////  Created by Gerdin Ventura on 3/27/21.
////
//
//import UIKit
//import Parse
//import AlamofireImage
//
//class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    @IBOutlet weak var profileImage: UIImageView!
//    @IBOutlet weak var descriptionTextField: UITextField!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let user = PFUser.current()
//        
////      Getting image
//        let imageFile = user!["profileImage"] as! PFFileObject
//        let imageFileUrl = imageFile.url!
//        let imageUrl = URL(string: imageFileUrl)
//        profileImage.af.setImage(withURL: imageUrl!)
//        
////        user["profileImage"]
//        
//    }
//    
//    @IBAction func onImageClick(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//        } else {
//            picker.sourceType = .photoLibrary
//        }
//        
//        present(picker, animated: true, completion: nil)
//    }
//    
//
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////      Resize the Image
//        let image = info[.editedImage] as! UIImage
//        let size = CGSize(width: 300, height: 300)
//        let imageScaled = image.af.imageAspectScaled(toFill: size)
//                
//        profileImage.image = imageScaled
//                
//        dismiss(animated: true, completion: nil) //Dismiss the camera view
//    }
//    
//    @IBAction func onSave(_ sender: Any) {
////        let user = PFUser.current()
//        
//        let userTable = PFObject(className: "User")
//
//        
//        let imageData = profileImage.image!.pngData()
//        let imageFile = PFFileObject(data: imageData!)
//        
//        userTable["profileImage"] = imageFile
//        
//        userTable.saveInBackground { (success, error) in
//            if success {
////                self.tabBarController?.view.removeFromSuperview()
//                print("Saved")
//            } else {
//                print("ERROR! \(String(describing: error))")
//            }
//        }
//    }
//}
