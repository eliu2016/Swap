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
                
               
                
                let middlename = (user?._middlename == nil && getSavedMiddlename() != nil)  ?getSavedMiddlename()! : ( user?._middlename ?? "")
                
                  let company = (user?._company == nil && getSavedCompany() != nil)  ? getSavedCompany()! : ( user?._company ?? "")
                
                  let website = (user?._website == nil && getSavedWebsite() != nil)  ?getSavedWebsite()! : ( user?._website ?? "")
                
                self.middleNameField.text = middlename
                self.companyField.text = company
                self.websiteField.text = website
                
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
