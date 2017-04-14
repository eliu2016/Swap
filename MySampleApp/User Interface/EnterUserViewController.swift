//
//  EnterUserViewController.swift
//  Swap
//
//  Created by David Slakter on 4/13/17.
//
//

import Foundation

class EnterUserViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    
    @IBAction func didTapNext(_ sender: Any) {
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
   
    
}
