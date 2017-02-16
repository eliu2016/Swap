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
        
        tableView.reloadData()
        
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
    private func calculateHoursBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .hour, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .hour, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    
    //table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if swapRequests.count == 0 && acceptedRequests.count == 0{
            
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
        }
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
        
        var hoursSinceNotification = 0
        var cell: notificationCell
        
        ///if (indexPath.section == 0){
        
            cell = tableView.dequeueReusableCell(withIdentifier: "privateSwapRequest", for: indexPath) as! notificationCell;
        
            cell.acceptButton.tag = indexPath.row
            circularImage(photoImageView: cell.profilePicture)
            SwapUser(username: swapRequests[indexPath.item]._sender!).getInformation { (error, user) in
            
            DispatchQueue.main.async {
                
                cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                cell.usernameLabel.text = user?._username
                
                 hoursSinceNotification = self.calculateHoursBetweenTwoDates(start: NSDate(timeIntervalSince1970: swapRequests[indexPath.item]._sent_at as! TimeInterval) as Date, end: Date())
    /*        }
        }
            
            
        }
        else {
            
             cell = tableView.dequeueReusableCell(withIdentifier: "acceptedSwapRequest", for: indexPath) as! notificationCell;
            
            cell.swapButton.tag = indexPath.row
            circularImage(photoImageView: cell.profilePicture)
            SwapUser(username: swapRequests[indexPath.item]._sender!).getInformation { (error, user) in
                
                DispatchQueue.main.async {
                    
                    cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                    cell.usernameLabel.text = user?._username
                    
                    hoursSinceNotification = self.calculateHoursBetweenTwoDates(start: NSDate(timeIntervalSince1970: swapRequests[indexPath.item]._sent_at  as! TimeInterval) as Date, end: Date())
                    
                }
            }
            
            
        }
        
        let daysSinceNotification = hoursSinceNotification/24
        let weeksSinceNotification = daysSinceNotification/7
        
        if hoursSinceNotification < 24{
            //express in hours
            
            cell.timeLabel.text = "\(hoursSinceNotification)h"
        }
        else if daysSinceNotification < 7{
            //express in days
            
            cell.timeLabel.text = "\(daysSinceNotification)d"
        }
        else {
            //express in weeks
        
            cell.timeLabel.text = "\(weeksSinceNotification)w"
        }*/
                }
        }
        return cell
        
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

    @IBAction func didAcceptRequest(_ sender: Any) {
        
        
        
    }
    @IBAction func didDeclineRequest(_ sender: Any) {
        
        
    }
    @IBAction func didPressSwap(_ sender: Any) {
        
        let vc = NotificationViewController(nibName: "NotificationView", bundle: nil)
        
        let usernameToSwapWith = acceptedRequests[(sender as AnyObject).tag]._sender!
        
        SwapUser().swapWith(userWithUsername: usernameToSwapWith, authorizeOnViewController: vc, overridePrivateAccount: true, completion: { (error, user) in
            
            SwapUser().confirmSwapRequestToUser(withUsername: usernameToSwapWith)
            
        })
        
        
        /*
         ******* On notifications, it should swap with the user regardless if they are private or not because notifications shows approved swap requests so this is redundant
     //if user is private
        
        swapButton.setImage(#imageLiteral(resourceName: "PendingNotificationsButton"), for: .normal)
        
    //else if user is not private
    
        swapButton.setImage(#imageLiteral(resourceName: "SwappedNotificationsButton"), for: .normal)
        */
        
    }
}


