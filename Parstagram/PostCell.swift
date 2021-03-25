//
//  PostCell.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var usernameLabelTop: UILabel!
    
    var delegateBtn: myBtnDelegate?
    
    var comments: [PFObject]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onComment(_ sender: Any) {
        delegateBtn?.commentBtnTapped(cell: self, objects: comments ?? [])
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

protocol myBtnDelegate {
    func commentBtnTapped(cell: PostCell, objects: [PFObject])
}

