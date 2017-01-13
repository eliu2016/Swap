//
//  ConfirmAccountViewController.swift
//  Swap
//
//  Created by Dr. Stephen, Ph.D on 12/8/16.
//
//

import UIKit

class ConfirmAccountViewController: UIViewController {
    
    @IBOutlet weak var confirmationCode: UITextField!
    
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    
    
    /// This variable should be located in whatever view controller is used to sign in
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?

    
    
    @IBAction func didTapResendConfirmationCode(_ sender: UIButton) {
        
        resendConfirmationCode(toUserWithUsername: getSavedUsername()!)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func didConfirmCode(_ sender: UIButton) {
        
        confirmUser(withCode: confirmationCode.text, username: getSavedUsername()!,
                    
        failed:{
            
            UIAlertView(title: "Error",
                        message: "Invalid Confirmation Code",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
            
            
        },
        
        
        succeded: {
            
            // Sign in the user 
            self.signIn()
            
        })
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        confirmationCode.becomeFirstResponder()
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
