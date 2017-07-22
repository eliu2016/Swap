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
    }
    @IBAction func didTapNext(_ sender: Any) {
    }
    @IBAction func didTapCancel(_ sender: Any) {
    }
 
    
}
