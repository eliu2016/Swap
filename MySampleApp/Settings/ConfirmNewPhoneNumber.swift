//
//  ConfirmNewPhoneNumber.swift
//  Swap
//
//  Created by David Slakter on 7/22/17.
//
//

import Foundation

class ConfirmNewPhoneNumber: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var Textfield1: UITextField!
    @IBOutlet var Textfield2: UITextField!
    @IBOutlet var Textfield3: UITextField!
    @IBOutlet var Textfield4: UITextField!
    @IBOutlet var Textfield5: UITextField!
    @IBOutlet var Textfield6: UITextField!
    
    
    @IBAction func enteredFirst(_ sender: Any) {
        
        Textfield2.becomeFirstResponder()
    }
    @IBAction func enteredSecond(_ sender: Any) {
        Textfield3.becomeFirstResponder()
    }
    @IBAction func enteredThird(_ sender: Any) {
        Textfield4.becomeFirstResponder()
    }
    @IBAction func enteredFourth(_ sender: Any) {
        Textfield5.becomeFirstResponder()
    }
    @IBAction func enteredFifth(_ sender: Any) {
        Textfield6.becomeFirstResponder()
    }
    @IBAction func enteredSixth(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
    
    
    @IBAction func SendCodeAgain(_ sender: Any) {
        
        pool.getUser(getUsernameOfSignedInUser()).getAttributeVerificationCode("phone_number")
   
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        
        guard  let number1 = Textfield1.text, let number2 = Textfield2.text, let number3 = Textfield3.text, let number4 = Textfield4.text, let number5 = Textfield5.text, let number6 = Textfield6.text else{
            
            return
        }
        
        let code = number1+number2+number3+number4+number5+number6
        
        pool.getUser(getUsernameOfSignedInUser()).verifyAttribute("phone_number", code: "\(code)").continue(with: AWSExecutor.mainThread(), with: { (task) -> Any? in
            
            DispatchQueue.main.async {
                
                
                if task.error != nil {
                    
                    // There was an error
                    // Possibly Wrong Code
                    UIAlertView(title: "Error",
                                message: "Invalid Confirmation Code",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    
                    // ** User presses cancel 
                    // *** clear out the entered numbers so the user can reenter the numbers
                    
                    
                } else {
                    
                    // Correct Code
                    
                    
                    UIAlertView(title: "Success",
                                message: "Phone number successfully changed",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    
                    //*** Go back to settings or profile
                    
                }
            }
          
            
           
        })
        
        
      
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        // *** Go back 
    }
 
    
}
