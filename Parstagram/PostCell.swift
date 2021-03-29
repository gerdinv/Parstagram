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
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    var delegateBtn: myBtnDelegate?
    var selectedPost: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onComment(_ sender: Any) {
        delegateBtn?.commentBtnTapped(cell: self, objects: selectedPost)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

protocol myBtnDelegate {
    func commentBtnTapped(cell: PostCell, objects: PFObject)
}

