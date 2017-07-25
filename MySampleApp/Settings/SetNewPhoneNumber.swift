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

class SetNewPhoneNumber: UIViewController, UITextFieldDelegate, CountryPickerDelegate {
    @IBOutlet var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet var CountryCodeButton: UIButton!
    @IBOutlet var ConfirmationView: UIView!
    @IBOutlet var CountryCodePicker: CountryPicker!
    
    var phoneNumber: String!
    var PhoneCode: String!
    
    var COUNTRYCODE: String!
    
    override func viewDidLoad() {
        phoneNumberTextField.delegate = self
        phoneNumberTextField.becomeFirstResponder()
        
        //get current country
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        
        //init Picker
        CountryCodePicker.countryPickerDelegate = self
        CountryCodePicker.showPhoneNumbers = true
        CountryCodePicker.setCountry(code!)

        
    }
    
    @IBAction func didTapCountryCode(_ sender: Any) {
        self.resignFirstResponder()
        
        view.endEditing(false)
    }
    @IBAction func didTapNext(_ sender: Any) {
        
        phoneNumber = "\(PhoneCode ?? "") \(phoneNumberTextField.text ?? "")"
        
        
        guard  phoneNumber.isPhoneNumber else {
            
            
            UIAlertView(title: "Invalid Phone Number", message: "Please enter a valid phone number.", delegate: self, cancelButtonTitle: "Ok").show()
            
            
            return
        }
        
        
        
        savePhonenumber(phone: "+\(phoneNumber.digits)")
        
        let alert = UIAlertController(title: "Change phone number associated with this Swap account?", message: "Your new phone number must be verified in order to reset your password. However, if you would like to keep using the phone number we already have verified in your account, press no. If you press no, we will still use this new number whenever you swap contacts with another user; however, you will not be able to use this number to reset your password.", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
            // Set New Phone Number in DynamoDB Without Changing in Amazon Cognito
            
            
            SwapUser().set(Phonenumber:  "+\(self.phoneNumber.digits)", ShouldChangePhoneNumberAssociation: false, DidSetInformation: { _ in
                
                     // ********Go back to Settings or back to profile
                
                return nil
            })
       
            
            
        }))
        
        
        
            alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { (action) in
                
                        // Show popup view
                        
                        
                       self.view.endEditing(true)
                        self.view.addSubview(self.ConfirmationView)
                        self.ConfirmationView.backgroundColor = UIColor.clear
                        self.ConfirmationView.center = self.view.center
                        self.ConfirmationView.transform =
                            CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                        self.ConfirmationView.alpha = 0
                        // Set the confirmation view text here
                //**********   THis is what the text on the pop up view should say
                      ///  self.ConfirmationView.text = "Send Confirmation Code to \(phoneNumber ?? "")?"
                        
                        UIView.animate(withDuration: 0.4){
                            
                          //  self.blurView.isHidden = false
                         //   self.blurView.alpha = 0.5
                            self.ConfirmationView.alpha = 1
                            self.ConfirmationView.transform = CGAffineTransform.identity
                        }
 
               
                
                
                
                
            }))
      
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        
        PhoneCode = phoneCode
        CountryCodeButton.setTitle(countryCode + " " + phoneCode, for: .normal)
        COUNTRYCODE = phoneCode
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSendSMS(_ sender: Any) {
        
        
        SwapUser().set(Phonenumber: "+\(self.phoneNumber.digits)", DidSetInformation: {  _ in
            
            
       
            
            DispatchQueue.main.async {
                
            
                
                self.performSegue(withIdentifier: "confirmNumber", sender: nil)
    
            }
        
            
        })
    }
    
    
    
    @IBAction func didTapCloseConfirmation(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2){
            
            self.ConfirmationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ConfirmationView.alpha = 0
          //  self.blurView.isHidden = true
            
        }
    }
   
}
