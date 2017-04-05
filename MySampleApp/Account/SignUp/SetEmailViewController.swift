//
//  SetEmailViewController.swift
//  Swap
//
//  Created by David Slakter on 3/12/17.
//
//

import Foundation


class setEmailViewController: UIViewController {

    //text field
    @IBOutlet var emailField: UITextField!
    
    
    override func viewDidLoad() {
        emailField.becomeFirstResponder()
    }

    @IBAction func didTapNext(_ sender: Any) {
        
        if (emailField.text?.isValidEmail())!{
                
                saveEmail(email: emailField.text!)
            
                self.performSegue(withIdentifier: "toUsernameController", sender: nil)
                
           }
        else{
            
            UIAlertView(title: "Invalid Email",
                        message: "Please Enter A Valid Email Address",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
        }
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
