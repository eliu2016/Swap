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
        

        
        guard  (newPasswordField.text != nil) && (newPasswordField.text?.characters.count)! >= 6 else {
            
            UIAlertView(title: "Invalid Password", message: "Password must be at least 6 characters.", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        let new_password = newPasswordField.text!
        
        
        confirmForgotPassword(username: getSavedUsername() ?? "", confirmation: getVerificationCodeForForgotPassword() ?? "", new: new_password) { (didSucceed) in
            
            
            guard didSucceed else{
                
                UIAlertView(title: "Invalid Verification Code", message: "Something went wrong, try again.", delegate: nil, cancelButtonTitle: "Ok").show()
                
               
                
                DispatchQueue.main.async {
                    
                 
                    
                    // Go back to sign in screen
                    
                    
                  // self.performSegue(withIdentifier: "leaveForgotPassword", sender: nil)
                    navigationController?.popToRootViewController(animated: true)  
                    
                }
                
                return
            }
            
            
            if didSucceed{
                
                
                let message = UIAlertController(title: "Success", message: "Your password has been changed.", preferredStyle: .alert)
                
                
                message.addAction(UIAlertAction(title: "Ok", style: .default){ (action) in
                    
                    
                    /// Password successfully reset
                    
                    DispatchQueue.main.async {
                        
                        
                        // Go back to sign in screen
                        
                          // self.performSegue(withIdentifier: "leaveForgotPassword", sender: nil)
                        navigationController?.popToRootViewController(animated: true)
                        
                    }
                    
                    
                })
                
                self.present(message, animated: true, completion: nil)

                
                
            }
        }
        

    }
}
