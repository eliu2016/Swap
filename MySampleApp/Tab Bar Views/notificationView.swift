//
//  notificationView.swift
//  Swap
//
//  Created by David Slakter on 1/21/17.
//
//

import Foundation

class notificationView: UITableViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.allowsSelection = false
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = .blue
        self.refreshControl?.tintColor = .white
        self.refreshControl?.addTarget(self, action: #selector(notificationView.refreshTable), for: .valueChanged)
        

    }
    
    
    //table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let blankTableMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        blankTableMessage.text = "No Notifications :'("
        blankTableMessage.textColor = .black
        blankTableMessage.textAlignment = NSTextAlignment.center
        blankTableMessage.font = UIFont(name: "Avenir-Next", size: 20)
        blankTableMessage.sizeToFit()
        
        self.tableView.backgroundView = blankTableMessage
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        return 1;
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageSwapRequests", for: indexPath);
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NotifySwap", for: indexPath)
  
        
            return cell
        
        
    }

    
    
    func refreshTable() {
        // Code to refresh table view  
        tableView.reloadData()
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
   
    
}
 class notificationCell: UITableViewCell {
    
}
