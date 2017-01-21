//
//  MoreInfo.swift
//  Swap
//
//  Created by David Slakter on 1/20/17.
//
//

import Foundation

class MoreInfo: UIViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}
class MoreInfoTable: UITableViewController {
   
    @IBOutlet var middleNameField: UITextField!
    @IBOutlet var companyField: UITextField!
    @IBOutlet var websiteField: UITextField!
    @IBOutlet var addressField: UITextField!

    override func viewDidLoad() {
        tableView.allowsSelection = false
    }

    
}
