//
//  SetNewPhoneNumber.swift
//  Swap
//
//  Created by David Slakter on 7/22/17.
//
//

import Foundation
import PhoneNumberKit
import CountryPicker

class SetNewPhoneNumber: UIViewController, UITextFieldDelegate {
    @IBOutlet var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet var CountryCodeButton: UIButton!
    @IBOutlet var ConfirmationView: UIView!
    @IBOutlet var CountryCodePicker: CountryPicker!
    
    override func viewDidLoad() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func didTapCountryCode(_ sender: Any) {
        self.resignFirstResponder()
    }
    @IBAction func didTapNext(_ sender: Any) {
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapSendSMS(_ sender: Any) {
    }
    @IBAction func didTapCloseConfirmation(_ sender: Any) {
    }
   
}
