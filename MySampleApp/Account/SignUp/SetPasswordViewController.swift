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
    
    
    @IBAction func didTapNext(_ sender: Any) {
        
        userDefaults.standard.set(passwordField.text, forKey: "password")
    }
}
