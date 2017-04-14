//
//  SearchUsersView.swift
//  Swap
//
//  Created by David Slakter on 1/9/17.
//
//

import Foundation
import Kingfisher

class SearchUsers: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
  
    
    let featuredCellID = "FCell"
    
    
    var collectionView: UICollectionView? = nil
    
    
    @IBOutlet var searchedUsersTable: UITableView!
   // @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchLabel: UILabel!
    
    var returnedUsers: [SwapUser] = []

    
    override func viewWillAppear(_ animated: Bool) {
        
        searchBar.becomeFirstResponder()
        
      /*  for indexpath in self.tableView.indexPathsForVisibleRows!{
            
            self.tableView.deselectRow(at: indexpath, animated: true)
            
        }*/
            
    }
    override func viewDidLoad() {
    
        searchBar.delegate = self
        
        
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //recognizes a tap on the screen
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        //set up collection view and add it to the view
        let collectionViewRect = CGRect(x: 0, y: 140, width: self.view.frame.width, height: self.view.frame.height*0.75)
        
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: collectionViewRect, collectionViewLayout: layout)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FeaturedProfilesCell.self, forCellWithReuseIdentifier: featuredCellID)
        
        self.view.addSubview(collectionView!)
        
        collectionView?.isHidden = true
       
    }
    func didTapScreen(){
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         collectionView?.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // collectionView?.isHidden = false
        
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Make sure that the input is not empty; otherwise, all usesrs will be returned
        
        guard !(searchBar.text?.isEmpty)! else {
            
            print("search is empty")
            return
        }
        
        searchLabel.text = searchText
        
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
        
        cell.selectionStyle = .none
        
        
        cell.username.text = returnedUsers[indexPath.item].username
        cell.profileImage.kf.indicatorType = .activity
        cell.profileImage.kf.setImage(with: returnedUsers[indexPath.item].profilePictureURL)
        circularImage(photoImageView: cell.profileImage)
        
        if (returnedUsers[indexPath.item].isVerified){
            
            cell.verifiedIcon.isHidden = false
            
        }
        else{
            cell.verifiedIcon.isHidden = true
        }
        
        return cell
    }
 
    
    //setup collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCellID, for: indexPath) as! FeaturedProfilesCell
        
        cell.contentView.frame = cell.bounds
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //number of featured profiles
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    
        return CGSize(width: view.frame.width, height: 130)
    }

}

class searchUsernamesCell: UITableViewCell {
    
    @IBOutlet weak var carrot: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet var verifiedIcon: UIImageView!
    
}
