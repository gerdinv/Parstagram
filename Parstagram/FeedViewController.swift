//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse
import AlamofireImage

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = minute * 60
        let day = hour * 24
        let week = day * 7
        
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) weeks ago"
        } else if secondsAgo < (week * 2) {
            print("")
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
    
        return formatter.string(from: self)
    }
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, myBtnDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    let numberOfPosts = 20
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadPosts()
        
        myRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        self.tableView.reloadData()
    }
    
    @objc func loadPosts() {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments","comments.author"])
        query.limit = numberOfPosts
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    func loadMorePosts() {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments","comments.author"])
        query.limit = numberOfPosts + 20
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count && posts.count > 20 {
            loadMorePosts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      Get Objects
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
    
//      Get post image
        let imageFile = post["image"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
        
//      Get user's profile image
        let profileImageFile = user["profileImage"] as! PFFileObject
        let profileFileUrl = profileImageFile.url!
        let profileImageUrl = URL(string: profileFileUrl)
        
//      Update screen elements
        cell.usernameLabel.text = user.username
        cell.usernameLabelTop.text = user.username
        cell.captionLabel.text = post["caption"] as? String
        cell.photoView.af.setImage(withURL: imageUrl!)
        cell.profilePhotoView.af.setImage(withURL: profileImageUrl!)
        
//      Set my delegate
        cell.selectedPost = post
        cell.delegateBtn = self
        
//      Makes profile picture round
        cell.profilePhotoView.layer.cornerRadius = cell.profilePhotoView.frame.size.width / 2
        cell.profilePhotoView.clipsToBounds = true
        
//      Time ago posted
        let date = post.createdAt!
        cell.timeAgoLabel.text = date.timeAgoDisplay()
        
        return cell
    }
    
    func commentBtnTapped(cell: PostCell, objects: PFObject) {
        self.performSegue(withIdentifier: "commentsViewSegue", sender: objects)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentsViewSegue" {
            let controller = segue.destination as! CommentsViewController
            controller.selectedPost = sender as! PFObject
        }
    }
    
}

