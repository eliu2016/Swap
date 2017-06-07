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
    
    var canUseUsername: Bool = false
    
    override func viewDidLoad() {
        
        usernameTextField.becomeFirstResponder()
        availabilityLabel.isHidden = true
        usernameTextField.delegate = self
        availabilityLabel.adjustsFontSizeToFitWidth = true
        usernameTextField.autocorrectionType = .no
    
    }
    @IBAction func didChangeUsername(_ sender: Any) {
        
         availabilityLabel.isHidden = false
    
        usernameTextField.text?.validate(completion: { (isValid, text) in
            
            DispatchQueue.main.async {
                
                if isValid {
                    
                    self.canUseUsername = true
                    self.availabilityView.backgroundColor = UIColor.green
                    self.availabilityLabel.text = "Username is avaliable."
                    
                } else{
                    
                    self.canUseUsername = false
                    self.availabilityView.backgroundColor = UIColor.red
                    self.availabilityLabel.text = text
                }
                
            }
           
            
        })
        
        
        
        
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        
        //save the username
        
        if canUseUsername{
            
            
            self.performSegue(withIdentifier: "toPasswordController", sender: nil)
            saveUsername(username: usernameTextField.text)
        }
        
        
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
