//
//  verificationViewController.swift
//  Swap
//
//  Created by David Slakter on 4/13/17.
//
//

import Foundation

class verificationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstNumberField: UITextField!
    @IBOutlet var secondNumberField: UITextField!
    @IBOutlet var thirdNumberField: UITextField!
    @IBOutlet var forthNumberField: UITextField!
    @IBOutlet var fifthNumberField: UITextField!
    @IBOutlet var sixthNumberField: UITextField!
    
    override func viewDidLoad() {
        firstNumberField.delegate = self
        secondNumberField.delegate = self
        thirdNumberField.delegate = self
        forthNumberField.delegate = self
        fifthNumberField.delegate = self
        sixthNumberField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    @IBAction func enteredFirst(_ sender: Any) {
        secondNumberField.becomeFirstResponder()
    }
    @IBAction func enteredSecond(_ sender: Any) {
        thirdNumberField.becomeFirstResponder()
    }
    @IBAction func enteredThird(_ sender: Any) {
        forthNumberField.becomeFirstResponder()
    }
    @IBAction func enteredForth(_ sender: Any) {
        fifthNumberField.becomeFirstResponder()
    }
    @IBAction func enteredFifth(_ sender: Any) {
        sixthNumberField.becomeFirstResponder()
    }
    @IBAction func enteredSixth(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func didTapNext(_ sender: Any) {
        
        guard  let number1 = firstNumberField.text, let number2 = secondNumberField.text, let number3 = thirdNumberField.text, let number4 = forthNumberField.text, let number5 = fifthNumberField.text, let number6 = sixthNumberField.text else{
            
            return
        }
        
        
        
        let code = number1+number2+number3+number4+number5+number6
       
        
        guard code.characters.count == 6 else {
            
            return
        }
        
        save(verificationCode: code)
        
        self.performSegue(withIdentifier: "showEnterNewPassword", sender: nil)
    
    }
    @IBAction func didTapSendCode(_ sender: Any) {
        
        guard getSavedUsername() != nil else {
            
            return
        }
        
        
        forgotPassword(username:  getSavedUsername() ?? "" ) { (isSuccess, destination) in
            
            
            guard isSuccess && destination != nil else {
                
                // Tell the user that the username/phone number account could not be found
                
                UIAlertView(title: "Invalid Username or Phone Number", message: "Sorry, could not find that account.", delegate:nil, cancelButtonTitle: "Ok").show()
                
                return
            }
            
            
            if isSuccess{
                
                print("is a success ! ")
                // Will send verification code
                // The string 'destination' is the email address or phone number the code was sent to
                
                
                let message = UIAlertController(title: "Reset Passord", message: "We sent a verification code to \(destination!)", preferredStyle: .alert)
                
                
                message.addAction(UIAlertAction(title: "Ok", style: .default){ (action) in
                    
                    
                    // Now go to the verification page
                    
                    DispatchQueue.main.async {
                        
                        
                    }
                    
                    
                    
                })
                
                self.present(message, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
}
