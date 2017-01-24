//
//  MoreInfo.swift
//  Swap
//
//  Created by David Slakter on 1/20/17.
//
//

import Foundation


class MoreInfoTable: UITableViewController {
   
    @IBOutlet public var middleNameField: UITextField!
    @IBOutlet var companyField: UITextField!
    @IBOutlet var websiteField: UITextField!
    @IBOutlet var addressField: UITextField!

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        SwapUser(username: getUsernameOfSignedInUser()).getInformation { (error, user) in
            
            
            DispatchQueue.main.async {
                
                self.middleNameField.text = user?._middlename
                self.companyField.text = user?._company
                self.websiteField.text = user?._website
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
    }

    
}
class MoreInfo: UIViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
