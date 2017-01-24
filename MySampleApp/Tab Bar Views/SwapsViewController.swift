//
//  SwapsViewController.swift
//  Swap
//
//  Created by David Slakter on 1/14/17.
//
//

import Foundation

class SwapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var swapHistoryUsers: [SwapHistory] = []
    
    override func viewDidLoad() {
        
        
        SwapUser().getSwapHistory { (error, swapHistory) in
            
            if error != nil{
                
                print("error retriving swap history")
            }
            else{

                DispatchQueue.main.async {
                    
                    self.swapHistoryUsers = swapHistory!
                    self.tableView.reloadData()
                    
                }
              
                
            }
   
        }
     
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swapHistoryUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "swapsCell", for: indexPath) as! swapsTableCell;
        
        let user = swapHistoryUsers[indexPath.item]
        
        cell.username.text = user._swapped
        cell.swapDate.text = "\(user._time as! Double)"
        
        
        return cell
    }
    
}

class swapsTableCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var swapDate: UILabel!
    @IBOutlet var username: UILabel!
}
