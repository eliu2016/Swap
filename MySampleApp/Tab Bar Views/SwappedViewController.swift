//
//  SwappedViewController.swift
//  Swap
//
//  Created by David Slakter on 1/15/17.
//
//

import Foundation

class SwappedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var swappedHistoryUsers: [SwapHistory] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        SwapUser().getSwappedHistory { (error, swappedHistory) in
            
            if error != nil{
                
                print("error retriving swapped history")
            }
            else{
                
                DispatchQueue.main.async {
                    
                    self.swappedHistoryUsers = swappedHistory!
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
        }
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swappedHistoryUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "swappedCell", for: indexPath) as! swappedTableCell;
        
        let user = swappedHistoryUsers[indexPath.item]
        
    
        cell.swapDate.text = user._time?.timeAgo()
       
        SwapUser(username: user._swap!).getInformation(completion: {(error, user) in
            
            cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
            circularImage(photoImageView: cell.profilePicture)
            
            DispatchQueue.main.async {
                
                cell.username.text = (user?._firstname)! + " " + (user?._lastname)!
                
            }
        })
      
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "ShowSwappedUserProfile", sender: nil)
        searchedUser = swappedHistoryUsers[indexPath.item]._swap!
        
    }
    
    
}

class swappedTableCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var swapDate: UILabel!
    @IBOutlet var username: UILabel!
}
