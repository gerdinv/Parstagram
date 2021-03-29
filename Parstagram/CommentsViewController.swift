//
//  CommentsViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/21/21.
//

import UIKit
import AlamofireImage
import Parse
import MessageInputBar

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedPost: PFObject!
    let commentBar = MessageInputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedPost["comments"] != nil{
            return (selectedPost["comments"] as AnyObject).count
        } else{
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        
//      Get comment and user
        let comments = selectedPost["comments"] as! [PFObject]
        let comment = comments[indexPath.row]
        let user = comment["author"] as! PFUser
        
//      Get user's profile image
        let profileImageFile = user["profileImage"] as! PFFileObject
        let profileFileUrl = profileImageFile.url!
        let profileImageUrl = URL(string: profileFileUrl)
        
//      Update elements
        cell.usernameLabel.text =  user.username
        cell.commentLabel.text = comment["text"] as? String
        cell.profileImage.af.setImage(withURL: profileImageUrl!)
        
//      Makes profile picture round
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
        
        return cell
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//      Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground(){(success, error) in
            if success {
                print("Comment Saved!")
            } else {
                print("Error saving comment!")
            }
        }

        tableView.reloadData()
        //Clear and dismiss input bar
        commentBar.inputTextView.text = nil
        becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deletePost(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deletePost(at indexPath: IndexPath) -> UIContextualAction{
        let currentUser = PFUser.current()
//      Get comment and user
        let comments = self.selectedPost["comments"] as! [PFObject]
        let comment = comments[indexPath.row]
        let commentAuthor = comment["author"] as! PFUser
        let objectId = comment.objectId!

        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if currentUser?.objectId == commentAuthor.objectId {
                let query = PFQuery(className:"Comments")
                    query.whereKey("objectId", equalTo:objectId)
                    query.limit = 1
                
                query.findObjectsInBackground { (commentsToDelete: [PFObject]?, error) in
                    if commentsToDelete != nil {
                        for singleComment in commentsToDelete! {
                            singleComment.deleteInBackground()
                            print("deleted")
                         }
                    }
                }
            }
            completion(true)
            self.tableView.reloadData()
        }
        return action
    }
}

