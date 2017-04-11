//
//  ConfirmAccountViewController.swift
//  Swap
//
//  Created by Dr. Stephen, Ph.D on 12/8/16.
//
//

import UIKit

class ConfirmAccountViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var field1: UITextField!
    @IBOutlet var field2: UITextField!
    @IBOutlet var field3: UITextField!
    @IBOutlet var field4: UITextField!
    @IBOutlet var field5: UITextField!
    @IBOutlet var field6: UITextField!
    
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    
    
    /// This variable should be located in whatever view controller is used to sign in
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        field5.delegate = self
        field6.delegate = self
        
        
        field1.becomeFirstResponder()
    }
    
    @IBAction func didTapResendConfirmationCode(_ sender: UIButton) {
        
        resendConfirmationCode(toUserWithUsername: getUsernameOfSignedInUser())
    }
    
    
    @IBAction func didConfirmCode(_ sender: UIButton) {
        
        guard  let number1 = field1.text, let number2 = field2.text, let number3 = field3.text, let number4 = field4.text, let number5 = field5.text, let number6 = field6.text else{
            
            return
        }
        
        let code = number1+number2+number3+number4+number5+number6
        confirmUser(withCode: code, username: getSavedUsername()!,
                    
        failed:{
            
            UIAlertView(title: "Error",
                        message: "Invalid Confirmation Code",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
            
            
        },
        
        
        succeded: {
            
            DispatchQueue.main.async {
                
                // Sign in the user
                self.signIn()
            }
            
            
        })
    }
    
   
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
    }
    
    @IBAction func enteredFirst(_ sender: Any) {
        
        field2.becomeFirstResponder()
    }

    @IBAction func enteredSecond(_ sender: Any) {
        field3.becomeFirstResponder()
    }
    @IBAction func enteredThird(_ sender: Any) {
        field4.becomeFirstResponder()
    }
    @IBAction func enteredFourth(_ sender: Any) {
        field5.becomeFirstResponder()
    }
    @IBAction func enteredFifth(_ sender: Any) {
        field6.becomeFirstResponder()
    }
    @IBAction func enteredSixth(_ sender: Any) {
        view.endEditing(true)
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
