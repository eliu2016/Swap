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
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var confirmationLabel: UILabel!
    @IBOutlet var SendSMSButton: UIButton!
    
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

        blurView.isHidden = true
        
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
        
        let alert = UIAlertController(title: "Change phone number associated with this Swap account?", message:"You have successfully changed the number used to swap contacts. Is this a new number you will be able to recieve text messages at?", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
            // Set New Phone Number in DynamoDB Without Changing in Amazon Cognito
            
            
            SwapUser().set(Phonenumber:  "+\(self.phoneNumber.digits)", ShouldChangePhoneNumberAssociation: false, DidSetInformation: { _ in
                
                self.dismiss(animated: true, completion: nil)
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
                      self.confirmationLabel.text = "Send Confirmation Code to \(self.phoneNumber ?? "")?"
                        
                        UIView.animate(withDuration: 0.4){
                            
                           self.blurView.isHidden = false
                            self.blurView.alpha = 0.5
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
        
        SendSMSButton.isEnabled = false
        
        SwapUser().set(Phonenumber: "+\(self.phoneNumber.digits)", DidSetInformation: {  _ in
            
            
       
            
            DispatchQueue.main.async {
                
            
                
                self.performSegue(withIdentifier: "confirmNumber", sender: nil)
    
            }
        
            
        })
    }
    
    
    
    @IBAction func didTapCloseConfirmation(_ sender: Any) {
        
        SendSMSButton.isEnabled = true
        
        UIView.animate(withDuration: 0.2){
            
            self.ConfirmationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.ConfirmationView.alpha = 0
            self.blurView.isHidden = true
            
        }
    }
   
}
