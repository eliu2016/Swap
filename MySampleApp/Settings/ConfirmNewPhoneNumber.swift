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
    
    override func viewDidLoad() {
        Textfield1.delegate = self
        Textfield2.delegate = self
        Textfield3.delegate = self
        Textfield4.delegate = self
        Textfield5.delegate = self
        Textfield6.delegate = self
    }
    
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
        
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
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
                    
                    self.Textfield1.text = ""
                    self.Textfield2.text = ""
                    self.Textfield3.text = ""
                    self.Textfield4.text = ""
                    self.Textfield5.text = ""
                    self.Textfield6.text = ""
                    
                } else {
                    
                    // Correct Code
                    
                    
                    UIAlertView(title: "Success",
                                message: "Phone number successfully changed",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
          
            
           
        })
        
        
      
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
 
    
}
