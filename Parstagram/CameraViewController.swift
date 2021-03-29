//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse
import AlamofireImage



class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var config = YPImagePickerConfiguration()
    
    var appearsss = true;
    var im: UIImage!
    var didEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        commentTextView.delegate = self
         
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo, .video]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
//        config.bottomMenuItemSelectedTextColour = UIColor(r: 38, g: 38, b: 38)
//        config.bottomMenuItemUnSelectedTextColour = UIColor(r: 153, g: 153, b: 153)
        config.maxCameraZoomFactor = 1.0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !didEdit {
            commentTextView.text = ""
            didEdit = true
        }
        
        imageView.image = im
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if appearsss {
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
    //                print(photo.fromCamera) // Image source (camera or library)
    //                print(photo.image) // Final image selected by the user
    //                print(photo.originalImage) // original image selected by the user, unfiltered
                    print(photo.modifiedImage) // Transformed image, can be nil
    //                print(photo.exifMeta) // Print exif meta data of original image.
                    self.im = photo.image
                }
                
                picker.dismiss(animated: true, completion: nil)
                print("picker dimiss")
            }
            present(picker, animated: true, completion: nil)
            print("present picker")
            appearsss = false
        } else {
            imageView.image = self.im
        }
        
        
    }


    
    
    @IBAction func onSubmit(_ sender: Any) {
        let post = PFObject(className: "Posts")
        let user = PFUser.current()!
        let imageData = imageView.image!.pngData()
        let imageFile = PFFileObject(data: imageData!)
        let num = user["numberOfPosts"] as! Int
        
        post["author"] = user
        post["caption"] = commentTextView.text
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
        let imageScaled = image.af.imageAspectScaled(toFill: size)
        
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
