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
    
    @IBOutlet var blurView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
    @IBOutlet var popUp: UIView!
    @IBOutlet var popUpLabel: UILabel!
    
    var phoneNumber: String!
    var PhoneCode: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        phoneNumberField.becomeFirstResponder()
        
        //blurview
        blurView.isHidden = true
        
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
        
        phoneNumber = PhoneCode +  phoneNumberField.text!
        
        view.endEditing(true)
        self.view.addSubview(popUp)
        popUp.backgroundColor = UIColor.clear
        popUp.center = self.view.center
        popUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUp.alpha = 0
        popUpLabel.text = "Send Confirmation to " + phoneNumber + "?"
        
        UIView.animate(withDuration: 0.4){
            
            self.blurView.isHidden = false
            self.blurView.alpha = 0.5
            self.popUp.alpha = 1
            self.popUp.transform = CGAffineTransform.identity
        }
        
    }
    @IBAction func didTapSendSMS(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toConfirmAccount", sender: nil)
        
        
    }
    @IBAction func didTapCancel(_ sender: Any) {
    
        UIView.animate(withDuration: 0.2){
            
            self.popUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUp.alpha = 0
            self.blurView.isHidden = true
           
        }
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
        
        PhoneCode = phoneCode
        countryCodeButton.setTitle(countryCode + " " + phoneCode, for: .normal)
        
    }
    
    
}
