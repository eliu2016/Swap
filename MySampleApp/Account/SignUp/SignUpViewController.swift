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
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var phonenumberField: PhoneNumberTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //Buttons
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    
    
    
    @IBAction func didTapNextToCreateAccount(_ sender: UIButton) {
        
    //show loading overlay
   let loadingOverlay = ShowLoadingOverlay()
   let blackOverlay = loadingOverlay.showBlackOverlay()
   let loadingSymbol = loadingOverlay.showLoadingSymbol()
        self.view.addSubview(blackOverlay)
        self.view.addSubview(loadingSymbol)
        

        let phoneNumberKit = PhoneNumberKit()
        var formattedPhoneNumber = ""
        
        do {
            let phoneNumber = try phoneNumberKit.parse(phonenumberField.text!)
            formattedPhoneNumber = PhoneNumberKit().format(phoneNumber, toType: .e164)
        }
        catch {
            print("Phone number parser error")
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
                break
                
            case .InvalidEmail:
                // Tell the user to enter a valid email address
                break
                
            case .InvalidPhonenumber:
                // Tell the user to enter a valid phone number
                break
                
            case .InvalidUsername:
                // Tell the user to enter a valid username format 
                break
                
            case .PasswordTooShort:
                // Tell the user that his/her password is too short - Must be at least 6 characters
                break
                
            case .UsernameTaken:
                // Tell the user to enter a different username 
                break
                
            case .UnknownSignUpError:
                // Some unknown error has occured ... Tell the user to try again 
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
