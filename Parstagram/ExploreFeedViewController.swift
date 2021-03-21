//
//  ExploreFeedViewController.swift
//  Parstagram
//
//  Created by Gerdin Ventura on 3/20/21.
//

import UIKit
import Parse
import AlamofireImage

class ExploreFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadPosts()
        setPostConfigurations()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreFeedCell", for: indexPath) as! ExploreFeedCell
        
        let post = posts[indexPath.row]
        
//      Get post image
        let imageFile = post["image"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
        
        cell.postView.af.setImage(withURL: imageUrl!)
        
        return cell
    }
    
    func loadPosts() {
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.order(byDescending: "createdAt")
    
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.collectionView.reloadData()
//              self.myRefreshControl.endRefreshing()
            }
        }
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
