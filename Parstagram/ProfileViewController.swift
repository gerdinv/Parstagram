//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/19/21.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
    var posts = [PFObject]()
    
    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadPosts()
        loadUserData()
        setPostConfigurations()
        
        myRefreshControl.addTarget(self, action: #selector(loadUserData), for: .valueChanged)
        collectionView.refreshControl = myRefreshControl
        
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        loadUserData()
        self.collectionView.reloadData()
    }
    
    func setPostConfigurations(){
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    
//      Makes it so that there are 3 posts per row
        let width = view.frame.size.width / 3
        layout.itemSize = CGSize(width: width, height: width * 1.35 )
    }
    
    @objc func loadUserData() {
        let user = PFUser.current()
        
//      Getting image
        let imageFile = user!["profileImage"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
        
        profileImage.af.setImage(withURL: imageUrl!)
        usernameLabel.text = user?.username
        profileDescriptionLabel.text = user!["description"] as! String
        
//      Makes profile picture round
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
//      Sets other fields
        let numOfPosts = user!["numberOfPosts"] as! Int
        postsCountLabel.text = "\(numOfPosts)"
        
        let followerCount = user!["followers"] as! Int
        followersCountLabel.text = "\(followerCount)"
        
        let followingCount = user!["following"] as! Int
        followingCountLabel.text = "\(followingCount)"
        
        self.myRefreshControl.endRefreshing()
    }
    
    @objc func loadPosts() {
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.order(byDescending: "createdAt")
    
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.collectionView.reloadData()
//              self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostGridCell", for: indexPath) as! ProfilePostGridCell
        let post = posts[indexPath.item]
        
//      Get post image
        let imageFile = post["image"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
        
        cell.profilePostView.af.setImage(withURL: imageUrl!)
        
        return cell
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
