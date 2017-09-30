//
//  MoreInfo.swift
//  Swap
//
//  Created by David Slakter on 1/20/17.
//
//

import Foundation

var moreInfoMiddleName = ""
var moreInfoCompany = ""
var moreInfoWebsite = ""



class MoreInfoTable: UITableViewController, UITextFieldDelegate {
   
    @IBOutlet public var middleNameField: UITextField!
    @IBOutlet var companyField: UITextField!
    @IBOutlet var websiteField: UITextField!


    
    override func viewWillAppear(_ animated: Bool) {
        
        
        SwapUser(username: getUsernameOfSignedInUser()).getInformation { (error, user) in
            
            
            DispatchQueue.main.async {
                
               
                
                let middlename = (user?._middlename == nil && getSavedMiddlename() != nil)  ?getSavedMiddlename()! : ( user?._middlename ?? "")
                
                  let company = (user?._company == nil && getSavedCompany() != nil)  ? getSavedCompany()! : ( user?._company ?? "")
                
                  let website = (user?._website == nil && getSavedWebsite() != nil)  ?getSavedWebsite()! : ( user?._website ?? "")
                
                self.middleNameField.text = middlename
                self.companyField.text = company
                self.websiteField.text = website
                
                var moreInfoMiddleName = middlename
                var moreInfoCompany = company
                var moreInfoWebsite = website
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
        middleNameField.delegate = self
        companyField.delegate = self
        websiteField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moreInfoMiddleName = middleNameField.text!
        moreInfoCompany = companyField.text!
        moreInfoWebsite = websiteField.text!
    }

    
}
class MoreInfo: UIViewController{
    
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    @IBAction func didTapBack(_ sender: Any) {
        
        activityView.isHidden = false
        activityView.startAnimating()
        
            SwapUser().updateProfileInfoWith(Middlename: moreInfoMiddleName,  Company: moreInfoCompany,Website: moreInfoWebsite,   DidSetInformation: {
            
            DispatchQueue.main.async {
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }, CannotSetInformation: {

            print("error setting basic profile info")
            
        })
    
    }
    override func viewDidLoad() {
        activityView.isHidden = true
        activityView.stopAnimating()
    }
    
}
