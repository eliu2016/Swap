// notificationView.swift
// Swap
//
// Created by David Slakter on 1/21/17.
//
//

import Foundation

var swapRequests: [SwapRequest] = []
var acceptedRequests: [SwapRequest] = []

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    
    var blankTableMessage: UILabel?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        save(screen: .NotificationsScreen)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        loadNotifications()
        
        // Listens for reload notifications notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadNotifications), name: .reloadNotifications, object: nil)
        
    }
    
    //table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if swapRequests.count == 0 && acceptedRequests.count == 0{
            
            self.tableView.backgroundView = blankTableMessage
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
            return 0
        }
            
        else{
            
            self.tableView.backgroundView = nil
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            if swapRequests.count == 0{
                return 0
            }
        }
        
        return UITableViewAutomaticDimension
        
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
            circularImageNoBorder(photoImageView: cell.profilePicture)
            cell.profilePicture.kf.indicatorType = .activity
            
            if let user = swapRequests[safe: indexPath.item]?.user{
                
                cell.profilePicture.kf.setImage(with: URL(string: (user._profilePictureUrl)!))
                cell.usernameLabel.text = (user._firstname)! + " " + (user._lastname)!
                cell.timeLabel.text = (swapRequests[safe: indexPath.item]?._sent_at)?.timeAgo()
            }
                
            else {
                
            SwapUser(username: swapRequests[safe: indexPath.item]?._sender ?? "" ).getInformation { (error, user) in
                
                DispatchQueue.main.async {
                    
                    
                    cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                    cell.usernameLabel.text = (user?._firstname)! + " " + (user?._lastname)!
                    cell.timeLabel.text = (swapRequests[safe: indexPath.item]?._sent_at)?.timeAgo()
                    
                    
                    swapRequests[safe: indexPath.item]?.user = user
                }
            }
            
        }
        
        }
            
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "acceptedSwapRequest", for: indexPath) as! notificationCell;
            
            cell.swapButton.tag = indexPath.row
            circularImageNoBorder(photoImageView: cell.profilePicture)
            cell.profilePicture.kf.indicatorType = .activity
            
            if let user = acceptedRequests[safe: indexPath.item]?.user{
                
                cell.profilePicture.kf.setImage(with: URL(string: (user._profilePictureUrl)!))
                cell.usernameLabel.text = (user._firstname)! + " " + (user._lastname)!
                cell.timeLabel.text = (acceptedRequests[safe: indexPath.item]?._sent_at)?.timeAgo()
                cell.swapButton.isHidden = true
                if (acceptedRequests[safe: indexPath.item]?._status ?? 0).boolValue{ cell.swapButton.isHidden = false}
                
            }
                
            else {
            SwapUser(username: acceptedRequests[safe: indexPath.item]?._requested ?? "").getInformation { (error, user) in
                
                DispatchQueue.main.async {
                    
                    
                    cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                    cell.usernameLabel.text = (user?._firstname)! + " " + (user?._lastname)!
                    cell.timeLabel.text = (acceptedRequests[safe: indexPath.item]?._sent_at)?.timeAgo()
                    cell.swapButton.isHidden = true
                    if (acceptedRequests[safe: indexPath.item]?._status ?? 0).boolValue{ cell.swapButton.isHidden = false}
                }
            }
            
            
        }
        
        
        }
        
        
        return cell
        
    }
    
    @IBAction func didAcceptRquest(_ sender: Any) {
        
        let usernameToSwapWith = swapRequests[safe: (sender as AnyObject).tag]?._sender ?? ""
        
        
        SwapUser().performActionOnSwapRequestFromUser(withUsername: usernameToSwapWith, doAccept: true, completion: {error  in
            
            
            
            if error == nil{
                // After Accepted or Rejected Swap Request
                // Should remove cell from table view
                DispatchQueue.main.async {
                    
                    swapRequests.remove(at: (sender as AnyObject).tag)
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    @IBAction func didDeclineRequest(_ sender: Any) {
        
        let usernameToSwapWith = swapRequests[safe: (sender as AnyObject).tag]?._sender ?? ""
        
        
        SwapUser().performActionOnSwapRequestFromUser(withUsername: usernameToSwapWith, doAccept: false, completion: {error  in
            
            
            
            if error == nil{
                // After Accepted or Rejected Swap Request
                // Should remove cell from table view
                DispatchQueue.main.async {
                    
                    swapRequests.remove(at: (sender as AnyObject).tag)
                    self.tableView.reloadData()
                }
                
            }
            
        })
        
    }
    @IBAction func didPressSwap(_ sender: Any) {
        
        let usernameToSwapWith = acceptedRequests[(sender as AnyObject).tag]._requested!
        
        SwapUser().swap(with: usernameToSwapWith, authorizeOnViewController: self, overridePrivateAccount: true, method: .username, completion: { (error, user) in
            
            SwapUser().confirmSwapRequestToUser(withUsername: usernameToSwapWith)
            
            DispatchQueue.main.async {
                acceptedRequests.remove(at: (sender as AnyObject).tag)
                self.tableView.reloadData()
                
                
                // Add Swap Points 
                let swap = SwapUser()
                let swapped = SwapUser(username: user?._username ?? "")
                
                SwapUser.giveSwapPointsToUsersWhoSwapped(swap: swap, swapped: swapped)
                
                
            }
            
        })
        
    }
    
    
    func setupViewController()  {
        
        tableView.delegate = self
        
        self.tableView.allowsSelection = false
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
    }
    
    
    
    
    func loadNotifications()  {
        
        
        tableView.reloadData()
        
        activityView.startAnimating()
        
        blankTableMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        blankTableMessage?.text = "No Swap Requests 😅"
        blankTableMessage?.textColor = .black
        blankTableMessage?.textAlignment = NSTextAlignment.center
        blankTableMessage?.font = UIFont(name: "Avenir-Medium", size: 17)
        blankTableMessage?.sizeToFit()
        blankTableMessage?.isHidden = true
        
        SwapUser(username: getUsernameOfSignedInUser()).getRequestedSwaps { (error, requests) in
            
            guard error == nil else {
                refreshControl.endRefreshing()
                return
            }
            if let requests = requests{
                
                
                swapRequests = requests
                
                
                SwapUser().getPendingSentSwapRequests { (error, aRequests) in
                    
                    
                    if let aRequests = aRequests{
                        
                        DispatchQueue.main.async {
                            
                            acceptedRequests = aRequests
                            self.activityView.stopAnimating()
                            self.tableView.reloadData()
                            
                            refreshControl.endRefreshing()
                            
                            
                            
                            if swapRequests.count > 0 || acceptedRequests.count > 0 {
                                
                                
                                self.blankTableMessage?.isHidden = true
                                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                                
                                
                            } else {
                                
                                self.blankTableMessage?.isHidden = false
                                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                }
                
                
            }
        }
        
        
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



extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
