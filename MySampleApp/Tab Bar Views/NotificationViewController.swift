//
//  notificationView.swift
//  Swap
//
//  Created by David Slakter on 1/21/17.
//
//

import Foundation



class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    var swapRequests: [SwapRequest] = []
    var acceptedRequests: [SwapRequest] = []
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var blankTableMessage: UILabel?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
        activityView.startAnimating()
        
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
                
                    self.swapRequests = requests
                     self.activityView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
        
        SwapUser().getPendingSentSwapRequests { (error, aRequests) in
            
            
            if let aRequests = aRequests{
                
                DispatchQueue.main.async {
              
                    self.acceptedRequests = aRequests
                     self.activityView.stopAnimating()
                    self.tableView.reloadData()
                }
                
                
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if swapRequests.count > 0 || acceptedRequests.count > 0 {
            
            blankTableMessage?.isHidden = true
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            
        } else {
            blankTableMessage?.isHidden = false
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
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
        
    
        if swapRequests.count == 0 && acceptedRequests.count == 0{
            
            blankTableMessage?.isHidden = false
            self.tableView.backgroundView = blankTableMessage
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
            return 0
        }
       
        else{
            
            blankTableMessage?.isHidden = true
             self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
 
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionName: String
        
    
        switch section {
        case 0:
            
            sectionName = "Swap Requests"
            break;
        case 1:
            sectionName = "Sent Requests"
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
     
        var cell: notificationCell
        
        if (indexPath.section == 0){
        
            cell = tableView.dequeueReusableCell(withIdentifier: "privateSwapRequest", for: indexPath) as! notificationCell;
        
            cell.acceptButton.tag = indexPath.row
            circularImage(photoImageView: cell.profilePicture)
            SwapUser(username: swapRequests[indexPath.item]._sender!).getInformation { (error, user) in
            
            DispatchQueue.main.async {
                
                cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                cell.usernameLabel.text = (user?._firstname)! + " " + (user?._lastname)!
                cell.timeLabel.text = (self.swapRequests[indexPath.item]._sent_at)?.timeAgo()
                
            }
          }
        }
        
        else {
            
                cell = tableView.dequeueReusableCell(withIdentifier: "acceptedSwapRequest", for: indexPath) as! notificationCell;
            
                cell.swapButton.tag = indexPath.row
                circularImage(photoImageView: cell.profilePicture)
                SwapUser(username: acceptedRequests[indexPath.item]._requested!).getInformation { (error, user) in
                
                DispatchQueue.main.async {
                    
                    cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                    cell.usernameLabel.text = (user?._firstname)! + " " + (user?._lastname)!
                    cell.timeLabel.text = (self.acceptedRequests[indexPath.item]._sent_at)?.timeAgo()
                    cell.swapButton.isEnabled = (self.acceptedRequests[indexPath.item]._status)!.boolValue
                
                }
            }
        }
        
        
        
        return cell
        
    }

    @IBAction func didAcceptRquest(_ sender: Any) {
        
        let usernameToSwapWith = swapRequests[(sender as AnyObject).tag]._sender!
        
        
        SwapUser().performActionOnSwapRequestFromUser(withUsername: usernameToSwapWith, doAccept: true, completion: {error  in
            
            
            
            if error == nil{
                // After Accepted or Rejected Swap Request
                // Should remove cell from table view
                DispatchQueue.main.async {
                    
                    self.swapRequests.remove(at: (sender as AnyObject).tag)
                    self.tableView.reloadData()
                }
            }
            
        })

    }
    @IBAction func didDeclineRequest(_ sender: Any) {
   
        let usernameToSwapWith = swapRequests[(sender as AnyObject).tag]._sender!
        
        
        SwapUser().performActionOnSwapRequestFromUser(withUsername: usernameToSwapWith, doAccept: false, completion: {error  in
            
            
            
            if error == nil{
                // After Accepted or Rejected Swap Request
                // Should remove cell from table view
                DispatchQueue.main.async {
                    
                    self.swapRequests.remove(at: (sender as AnyObject).tag)
                    self.tableView.reloadData()
                }
                
            }
            
        })
        
    }
    @IBAction func didPressSwap(_ sender: Any) {
        
        let usernameToSwapWith = acceptedRequests[(sender as AnyObject).tag]._requested!
        
        SwapUser().swapWith(userWithUsername: usernameToSwapWith, authorizeOnViewController: self, overridePrivateAccount: true, method: .username, completion: { (error, user) in
            
            SwapUser().confirmSwapRequestToUser(withUsername: usernameToSwapWith)
            
            DispatchQueue.main.async {
                self.acceptedRequests.remove(at: (sender as AnyObject).tag)
                self.tableView.reloadData()
            }
            
        })
        
        
        ////else if user is not private
        
        //swapButton.setImage(#imageLiteral(resourceName: "SwappedNotificationsButton"), for: .normal)
        
        
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
    @IBOutlet var timeLabel: UILabel!

    
    
    
}



