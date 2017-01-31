//
//  SearchUsersView.swift
//  Swap
//
//  Created by David Slakter on 1/9/17.
//
//

import Foundation
import Kingfisher

class SearchUsers: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
  
    
    @IBOutlet var searchedUsersTable: UITableView!
   // @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var returnedUsers: [SwapUser] = []

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func viewDidLoad() {
    
        searchBar.delegate = self
        
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
     
        /*setup collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false*/
        
    
    }
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Make sure that the input is not empty; otherwise, all usesrs will be returned
        
        guard !(searchBar.text?.isEmpty)! else {
            
            print("search is empty")
            return
        }
        
     searchUsers(withUsername: searchBar.text!) { (error, users) in
        
        if error != nil{
            print(error?.localizedDescription ?? "error searching usernames")
        }
        else{
            
            DispatchQueue.main.async {
                
                self.returnedUsers = users ?? []
                
                
                self.searchedUsersTable.reloadData()
                
            }
            
           
        }
        
     }
        
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
      
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let username = returnedUsers[indexPath.item].username
    
        searchedUser = username
        performSegue(withIdentifier: "showUserProfile", sender: nil)
    }
    
    //setup table view
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnedUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! searchUsernamesCell;
        
        cell.username.text = returnedUsers[indexPath.item].username

        cell.profileImage.kf.setImage(with: returnedUsers[indexPath.item].profilePictureURL)
        circularImage(photoImageView: cell.profileImage)
        
        if (!returnedUsers[indexPath.item].isVerified){
            
            cell.verifiedIcon.isHidden = true
            
        }
        
        return cell
    }
 
    
    //setup collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //number of featured profiles
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath) as! featuredProfilesCell
        
      
        cell.contentView.frame = cell.bounds
        cell.username.text = "featured"
        
        return cell
       
    }
    
    
}

class searchUsernamesCell: UITableViewCell {
    
    @IBOutlet weak var carrot: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet var verifiedIcon: UIImageView!
    
}
class featuredProfilesCell: UICollectionViewCell{
    
    @IBOutlet var featuredProfileImage: UIImageView!
    @IBOutlet var username: UILabel!
    
}

