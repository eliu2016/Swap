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
        
    
    }
    @IBAction func didTapSendCode(_ sender: Any) {
        
        
    }
    
}
