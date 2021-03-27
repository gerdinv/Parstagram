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
    
    let myRefreshControl = UIRefreshControl() 
    
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
//        print(comments)
//        print(selectedPost)
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
        let comments = selectedPost["comments"] as! [PFObject]
        
//        print(comments)
        let comment = comments[indexPath.row]
//        let user = comment["author"] as! PFUser
//        cell.usernameLabel.text =  "TE" //user.username
        cell.commentLabel.text = comment["text"] as! String
        
        return cell
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//        Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
//
        selectedPost.saveInBackground(){(success, error) in
            if success {
                print("Comment Saved!")
            } else {
                print("Error saving comment!")
            }
        }
        
//        print(comments)
        tableView.reloadData()
        //        post.add(comment, forKey: "comments")
        //
        //        post.saveInBackground { (success, error) in
        //            if success {
        //                print("comment saved")
        //            } else {
        //                print("error saving comment")
        //            }
        //        }
        
        //Clear and dismiss input bar
        commentBar.inputTextView.text = nil
        becomeFirstResponder()
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

