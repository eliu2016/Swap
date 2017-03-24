//
//  SignUpViewController.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/8/16.
//
//

import UIKit
import PhoneNumberKit

class SignUpViewController: UIViewController {
    
    //Text Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var phonenumberField: UITextField!
    @IBOutlet var passwordField: PhoneNumberTextField!

    //Buttons
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    
    
    
    @IBAction func didTapNextToCreateAccount(_ sender: UIButton) {
        
    //show loading overlay
   let loadingOverlay = ShowLoadingOverlay()
   let blackOverlay = loadingOverlay.showBlackOverlay()
        let loadingSymbol = loadingOverlay.showLoadingSymbol(view: self.view)
        self.view.addSubview(blackOverlay)
        self.view.addSubview(loadingSymbol)
        

        let phoneNumberKit = PhoneNumberKit()
        var formattedPhoneNumber = ""
        
        do {
            let phoneNumber = try phoneNumberKit.parse(phonenumberField.text!)
            formattedPhoneNumber = PhoneNumberKit().format(phoneNumber, toType: .e164)
        }
        catch {
            
            UIAlertView(title: "Could Not Create Account",
                        message: "Please enter a valid phone number.",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
        }
       
        
        createAccount(username: usernameField.text,
                      password: passwordField.text,
                      email: emailField.text,
                      phonenumber: formattedPhoneNumber,
                      
        failedToCreateAccount:{ signUpError in
            
            blackOverlay.isHidden = true
            loadingSymbol.isHidden = true
                    
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
            
        },
        
        
        didCreateAccount: {
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "toConfirmAccount", sender: nil)
            }
            
            
            
        })
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
