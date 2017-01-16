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
        
        cell.username.text = user._swap
        cell.swapDate.text = "\(user._time as! Double)"
        
        
        return cell
    }
    
}

class swappedTableCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var swapDate: UILabel!
    @IBOutlet var username: UILabel!
}
