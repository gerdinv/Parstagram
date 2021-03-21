//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse
import AlamofireImage


class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }


    @IBAction func onSubmit(_ sender: Any) {
        let post = PFObject(className: "Posts")
        let user = PFUser.current()!
        let imageData = imageView.image!.pngData()
        let imageFile = PFFileObject(data: imageData!)
        let num = user["numberOfPosts"] as! Int
        
        post["author"] = user
        post["caption"] = commentTextField.text
        post["image"] = imageFile
        user["numberOfPosts"] = num + 1
        
        post.saveInBackground { (success, error) in
            if success {
                self.tabBarController?.view.removeFromSuperview()
                print("Saved")
            } else {
                print("ERROR! \(String(describing: error))")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
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
        let imageScaled = image.af.imageScaled(to: size)
        
        imageView.image = imageScaled
        
        dismiss(animated: true, completion: nil) //Dismiss the camera view
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
