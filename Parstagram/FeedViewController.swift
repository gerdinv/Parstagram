//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/18/21.
//

import UIKit
import Parse
import AlamofireImage

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
        query.includeKeys(["author", "comments"])
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
        query.includeKeys(["author", "comments"])
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
        if indexPath.row + 1 == posts.count {
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
        
        cell.comments = post["comments"] as? [PFObject]
        cell.delegateBtn = self
        
        
        
//      Makes profile picture round
        cell.profilePhotoView.layer.cornerRadius = cell.profilePhotoView.frame.size.width / 2
        cell.profilePhotoView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comment = post 
//        let comment = (post["comments"] as? [PFObject]) ?? []
//        let selectedPost = post
    }
    
    func commentBtnTapped(cell: PostCell, objects: [PFObject]) {
        self.performSegue(withIdentifier: "commentsViewSegue", sender: objects)
//        print(objects)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentsViewSegue" {
            let controller = segue.destination as! CommentsViewController
            controller.comments = sender as? [PFObject] ?? []
        }
    }
    
}

