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
    @IBOutlet var sendSMSButton: UIButton!
    
    var phoneNumber: String!
    var PhoneCode: String!
    
    var COUNTRYCODE: String!
    
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
        
        phoneNumber = "\(PhoneCode ?? "") \(phoneNumberField.text ?? "")"
        
        
        guard  phoneNumber.isPhoneNumber else {
            
            
            UIAlertView(title: "Invalid Phone Number", message: "Please enter a valid phone number.", delegate: self, cancelButtonTitle: "Ok").show()
            
            
            return
        }
        
        savePhonenumber(phone: "+\(phoneNumber.digits)")
        print("the number is .... +\(phoneNumber.digits)")
        view.endEditing(true)
        self.view.addSubview(popUp)
        popUp.backgroundColor = UIColor.clear
        popUp.center = self.view.center
        popUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUp.alpha = 0
        popUpLabel.text = "Send Confirmation Code to \(phoneNumber ?? "")?"
        
        UIView.animate(withDuration: 0.4){
            
            self.blurView.isHidden = false
            self.blurView.alpha = 0.5
            self.popUp.alpha = 1
            self.popUp.transform = CGAffineTransform.identity
        }
        
    }
    @IBAction func didTapSendSMS(_ sender: Any) {
        
        sendSMSButton.isEnabled = false
        
        // Create an account 
        createAccount(username: getUsernameOfSignedInUser(), password: getPassword(), email: getSavedEmail(), phonenumber: getPhoneNumber(), failedToCreateAccount: { signUpError in
            
            DispatchQueue.main.async {
                
                
                
                switch signUpError{
                    
                case .EmptyFields:
                    // Tell the user to enter required fields
                    UIAlertView(title: "Could Not Create Account",
                                message: "Please ensure you completed the sign up process and try again.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    break
                    
                case .InvalidEmail:
                    // Tell the user to enter a valid email address
                    
                    UIAlertView(title: "Invalid Email Address",
                                message: "Please enter a valid email address.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    
                    break
                    
                case .InvalidPhonenumber:
                    // Tell the user to enter a valid phone number
                    
                    UIAlertView(title: "Invalid Phone Number",
                                message: "Please enter a valid phone number.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    
                    break
                    
                case .InvalidUsername:
                    // Tell the user to enter a valid username format
                    UIAlertView(title: "Invalid Username",
                                message: "Usernames can be no longer than 18 characters and cannot contain special characters.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    break
                    
                case .PasswordTooShort:
                    // Tell the user that his/her password is too short - Must be at least 6 characters
                    UIAlertView(title: "Invalid Password",
                                message: "Password must be at least 6 characters.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    break
                    
                case .UsernameTaken:
                    // Tell the user to enter a different username
                    UIAlertView(title: "Username Taken",
                                message: "Please enter a different username.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    break
                    
                case .UnknownSignUpError:
                    // Some unknown error has occured ... Tell the user to try again
                    UIAlertView(title: "Try Again",
                                message: "Check internet connection and try again.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                    break
                    
                    
                    
                }
                
                self.sendSMSButton.isEnabled = true
                
            }
            
            
            
        }, didCreateAccount: {
            // created an account
            
            print("Created An Account")
            
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "toConfirmAccount", sender: nil)
                
            }
        })

        
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
        COUNTRYCODE = phoneCode
        
    }
    
    
}


extension String {
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
