//
//  setPhoneNumber.swift
//  Swap
//
//  Created by David Slakter on 3/14/17.
//
//

import Foundation
import PhoneNumberKit
import CountryPicker


class setPhoneNumberViewController: UIViewController, CountryPickerDelegate {
    
    @IBOutlet var phoneNumberField: PhoneNumberTextField!
    
    @IBOutlet var picker: CountryPicker!
 
    @IBOutlet var countryCodeButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        phoneNumberField.becomeFirstResponder()
        
        //get current country
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
     
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapNext(_ sender: Any) {
        
        
        
    }
    
    @IBAction func didChangeCountryCode(_ sender: Any) {
        
        view.endEditing(false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // a picker item was selected
    public func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        countryCodeButton.setTitle(countryCode + " " + phoneCode, for: .normal)
        
    }
    
    
}
