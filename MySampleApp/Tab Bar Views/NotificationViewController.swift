//
//  notificationView.swift
//  Swap
//
//  Created by David Slakter on 1/21/17.
//
//

import Foundation

class NotificationViewController: UIViewController, UITableViewDataSource
{
    
    var swapRequests: [SwapRequest] = []
    var refreshControl: UIRefreshControl = UIRefreshControl()
   
    
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
       
        SwapUser().getRequestedSwaps { (error, requests) in
            
            if let requests = requests{
                
                DispatchQueue.main.async {
                    
                    self.swapRequests = requests
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.allowsSelection = false
        
        tableView.addSubview(refreshControl)
        self.refreshControl.tintColor = .black
        self.refreshControl.addTarget(self, action: #selector(NotificationViewController.refreshTable), for: .valueChanged)
        
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)

    }
    
    
    //table view
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if swapRequests.count == 0{
            
            let blankTableMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
            blankTableMessage.text = "No Notifications :'("
            blankTableMessage.textColor = .black
            blankTableMessage.textAlignment = NSTextAlignment.center
            blankTableMessage.font = UIFont(name: "Avenir-Next", size: 20)
            blankTableMessage.sizeToFit()
        
            self.tableView.backgroundView = blankTableMessage
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return swapRequests.count;
        
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "privateSwapRequest", for: indexPath) as! notificationCell;
        
       cell.usernameLabel.text = swapRequests[indexPath.item]._sender
        
        
            return cell
    }

    
    func refreshTable() {
        // Code to refresh table view  
        tableView.reloadData()
    
    }
    
}


 class notificationCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declineButton: UIButton!
}
