//
//  SearchUsersView.swift
//  Swap
//
//  Created by David Slakter on 1/9/17.
//
//

import Foundation
import Kingfisher

class SearchUsers: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UISearchBarDelegate {
  
    
    @IBOutlet var searchedUsersTable: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var returnedUsers: [SwapUser] = []

    
    override func viewDidLoad() {
    
        
    self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
        
    self.automaticallyAdjustsScrollViewInsets = false;
        
     
    //setup collection view layout
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = layout
    collectionView.showsHorizontalScrollIndicator = false
        
    
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
// Make sure that the input is not empty; otherwise, all usesrs will be returned
        
        guard !(searchBar.text?.isEmpty)! else {
            
            print("it is empty")
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
    
    //setup table view
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnedUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! searchUsernamesCell;
        
        cell.username.text = returnedUsers[indexPath.item].username

        cell.profileImage.kf.setImage(with: returnedUsers[indexPath.item].profilePictureURL)
        
        
        return cell
    }
 
    
    //setup collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath) as! featuredProfilesCell
        
        cell.clipsToBounds = true
        cell.username.text = "featured"
        
        return cell
       
    }
    
    
}

class searchUsernamesCell: UITableViewCell {
    
    @IBOutlet weak var carrot: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
}
class featuredProfilesCell: UICollectionViewCell{
    
    @IBOutlet var featuredProfileImage: UIImageView!
    @IBOutlet var username: UILabel!
    
}

