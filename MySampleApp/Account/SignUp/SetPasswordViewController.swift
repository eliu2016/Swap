//
//  SetPasswordViewController.swift
//  Swap
//
//  Created by David Slakter on 3/12/17.
//
//

import Foundation


class setPasswordViewController: UIViewController{
    
    
    @IBOutlet var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        passwordField.becomeFirstResponder()
    }
    
    
    @IBAction func didTapNext(_ sender: Any) {
        
        if (passwordField.text?.length)! >= 6{
           
            
            savePassword(password: passwordField.text)
            
            self.performSegue(withIdentifier: "toPhoneNumberController", sender: nil)
        }
        else{
          
            UIAlertView(title: "Error",
                        message: "Password Must Be 6 Characters",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
        }
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}
