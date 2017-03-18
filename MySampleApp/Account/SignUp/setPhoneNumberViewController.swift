//
//  setPhoneNumber.swift
//  Swap
//
//  Created by David Slakter on 3/14/17.
//
//

import Foundation
import PhoneNumberKit


class setPhoneNumberViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var phoneNumberField: PhoneNumberTextField!
    
 
    @IBOutlet var countryCodeButton: UIButton!
    
    override func viewDidLoad() {
        
   
        phoneNumberField.becomeFirstResponder()
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didChangeCountryCode(_ sender: Any) {
    }
  
    
}
