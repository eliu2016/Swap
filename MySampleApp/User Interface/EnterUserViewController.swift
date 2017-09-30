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
        
        guard !(usernameField.text?.isEmpty)! else {
            
            return
        }
        
        
        forgotPassword(username: usernameField.text ?? "" ) { (isSuccess, destination) in
            
            print("is success : \(isSuccess) \n destination: \(destination)")
            guard isSuccess && destination != nil else {
               
                // Tell the user that the username/phone number account could not be found
            
                UIAlertView(title: "Invalid Username or Phone Number", message: "Sorry, could not find that account.", delegate:nil, cancelButtonTitle: "Ok").show()
                
                return
            }
            
            
            if isSuccess{
                
                print("is a success ! ")
                // Will send verification code
                // The string 'destination' is the email address or phone number the code was sent to 
              
                
                let message = UIAlertController(title: "Reset Password", message: "We sent a verification code to \(destination!)", preferredStyle: .alert)
                
                
                message.addAction(UIAlertAction(title: "Ok", style: .default){ (action) in
                
                
                    // Now go to the verification page 
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "showVerification", sender: nil)
                    }
                    
                    
                    
                })
                
                self.present(message, animated: true, completion: nil)
                
            }
        }
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
   
    
}
