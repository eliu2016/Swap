//
//  SetUsernameViewController.swift
//  Swap
//
//  Created by David Slakter on 3/23/17.
//
//

import Foundation


class SetUsernameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var availabilityView: UIView!
    @IBOutlet var availabilityLabel: UILabel!
    
    override func viewDidLoad() {
        
        usernameTextField.becomeFirstResponder()
        availabilityLabel.isHidden = true
        usernameTextField.delegate = self
    
    }
    @IBAction func didChangeUsername(_ sender: Any) {
        
         availabilityLabel.isHidden = false
        
        if (usernameTextField.text?.isAValidUsername())!{
            
            availabilityView.backgroundColor = UIColor.green
            availabilityLabel.text = "Username is available"
        }
        else{
            
            availabilityView.backgroundColor = UIColor.red
            availabilityLabel.text = "Username not available"
        }
        
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        
        //save the username
        
        self.performSegue(withIdentifier: "toPasswordController", sender: nil)
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
