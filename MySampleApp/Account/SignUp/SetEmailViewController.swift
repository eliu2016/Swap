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
    

    @IBAction func didTapNext(_ sender: Any) {
        
        UserDefaults.standard.set(emailField.text, forKey: "email")
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
