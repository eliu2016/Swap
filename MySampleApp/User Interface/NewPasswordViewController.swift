//
//  NewPasswordViewController.swift
//  Swap
//
//  Created by David Slakter on 4/13/17.
//
//

import Foundation

class NewPasswordViewController: UIViewController{
    
    @IBOutlet var newPasswordField: UITextField!
    @IBOutlet var showPasswordButton: UIButton!
    
    var passwordSecure = true
    
    @IBAction func togglePasswordEncryption(_ sender: Any) {
        
        passwordSecure = !newPasswordField.isSecureTextEntry
        
        newPasswordField.isSecureTextEntry = passwordSecure
        
        if (passwordSecure){
            showPasswordButton.setTitle("Show Password", for: .normal)
        }
        else{
            showPasswordButton.setTitle("Hide Password", for: .normal)
        }
        
    }
    @IBAction func didTapDone(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
}
