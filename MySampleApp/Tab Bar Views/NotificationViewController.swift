//
//  notificationView.swift
//  Swap
//
//  Created by David Slakter on 1/21/17.
//
//

import Foundation


 var swapRequests: [SwapRequest] = []
 var acceptedRequests: [SwapRequest] = []

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var blankTableMessage: UILabel?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        blankTableMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        blankTableMessage?.text = "No Notifications :'("
        blankTableMessage?.textColor = .black
        blankTableMessage?.textAlignment = NSTextAlignment.center
        blankTableMessage?.font = UIFont(name: "Avenir-Next", size: 20)
        blankTableMessage?.sizeToFit()
        blankTableMessage?.isHidden = true
       
        SwapUser(username: getUsernameOfSignedInUser()).getRequestedSwaps { (error, requests) in
            
            if let requests = requests{
                
                DispatchQueue.main.async {
                    
                    
                    swapRequests = requests
                    self.tableView.reloadData()
                }
            }
        }
        
        SwapUser().getPendingSentSwapRequests { (error, aRequests) in
            
            
            if let aRequests = aRequests{
                
                acceptedRequests = aRequests
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    
        self.tableView.allowsSelection = true
        
        
        tableView.addSubview(refreshControl)
        self.refreshControl.tintColor = .black
        self.refreshControl.addTarget(self, action: #selector(NotificationViewController.refreshTable), for: .valueChanged)
        
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)

    }
    
    
    //table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
        
       /* if swapRequests.count == 0 && acceptedRequests.count == 0{
            
            blankTableMessage?.isHidden = true
            
            return 0
        }
        else if swapRequests.count == 0 || acceptedRequests.count == 0{
            
            
            blankTableMessage?.isHidden = false
            self.tableView.backgroundView = blankTableMessage
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
            return 1
        }
            
        else{
            
            
            blankTableMessage?.isHidden = false
            self.tableView.backgroundView = blankTableMessage
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
            return 2
        }*/
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionName: String
        
        switch section {
        case 0:
            sectionName = "Swap Requests"
            break;
        case 1:
            sectionName = "Accepted Requests"
            break;
        default:
            sectionName = ""
        }
        
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        if section == 0{
            return swapRequests.count
        }
        else if section == 1{
            return acceptedRequests.count
        }
        else{
            return 0
        }
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "privateSwapRequest", for: indexPath) as! notificationCell;
        
            cell.acceptButton.tag = indexPath.row
            circularImage(photoImageView: cell.profilePicture)
        SwapUser(username: swapRequests[indexPath.item]._sender!).getInformation { (error, user) in
            
            DispatchQueue.main.async {
                
                cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                cell.usernameLabel.text = user?._username
                
            }
        }
            
        return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "acceptedSwapRequest", for: indexPath) as! notificationCell;
            
            cell.swapButton.tag = indexPath.row
            circularImage(photoImageView: cell.profilePicture)
            SwapUser(username: swapRequests[indexPath.item]._sender!).getInformation { (error, user) in
                
                DispatchQueue.main.async {
                    
                    cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                    cell.usernameLabel.text = user?._username
                    
                }
            }
            
            return cell
        }
        
    }

    
    func refreshTable() {
        // Code to refresh table view  
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
}

 class notificationCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var swapButton: UIButton!

    @IBAction func didAcceptRequest(_ sender: Any) {
        
        
        
    }
    @IBAction func didDeclineRequest(_ sender: Any) {
        
        
    }
    @IBAction func didPressSwap(_ sender: Any) {
        
        let swappedUser = acceptedRequests[(sender as AnyObject).tag]._sender!
        
        SwapUser().confirmSwapRequestToUser(withUsername: swappedUser)
        
    }
}


