//
//  SignInViewController.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/8/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import FacebookLogin

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var SignInButton: UIButton!
    @IBOutlet var SignUpButton: UIButton!
    
    @IBOutlet var passwordBottom: UIImageView!
    var blackOverlay: UIImageView?
    var loadingSymbol: UIImageView?
    
    @IBOutlet var orLabel: UILabel!
    
    /// This variable should be located in whatever view controller is used to sign in
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?
    
    
    let FBLoginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
      
        //loading
        let loadingOverlay = ShowLoadingOverlay()
        
        blackOverlay = loadingOverlay.showBlackOverlay()
        loadingSymbol = loadingOverlay.showLoadingSymbol(view: self.view)
        
        self.view.addSubview(blackOverlay!)
        self.view.addSubview(loadingSymbol!)
        
        //disable UI Components
        SignInButton.isEnabled = false
        SignUpButton.isEnabled = false
        usernameField.isEnabled = false
        passwordField.isEnabled = false
        
        //drop keyboard
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        
        signIn()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        usernameField.delegate = self
        passwordField.delegate = self
        
        
        usernameField.attributedPlaceholder = NSAttributedString(string: "username",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
        

        // Do any additional setup after loading the view.
        
        FBLoginButton.center = CGPoint(x: view.center.x, y: view.center.y + 200)
        FBLoginButton.frame.size = CGSize(width: 250, height: 40)
        
        view.addSubview(FBLoginButton)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        orLabel.isHidden = true
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        SignInButton.frame = CGRect(x: SignInButton.frame.origin.x, y: SignInButton.frame.origin.y - 60, width: SignInButton.frame.width, height: SignInButton.frame.height)
        
        SignUpButton.frame = CGRect(x: SignUpButton.frame.origin.x, y: SignUpButton.frame.origin.y - 85, width: SignUpButton.frame.width, height: SignUpButton.frame.height)
        
        passwordField.frame = CGRect(x: passwordField.frame.origin.x, y: passwordField.frame.origin.y - 25, width: passwordField.frame.width, height: passwordField.frame.height)
        passwordBottom.frame = CGRect(x: passwordBottom.frame.origin.x, y: passwordBottom.frame.origin.y - 25, width: passwordBottom.frame.width, height: passwordBottom.frame.height)
        
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        orLabel.isHidden = false
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        
         SignInButton.frame = CGRect(x: SignInButton.frame.origin.x, y: SignInButton.frame.origin.y + 60, width: SignInButton.frame.width, height: SignInButton.frame.height)
        
        SignUpButton.frame = CGRect(x: SignUpButton.frame.origin.x, y: SignUpButton.frame.origin.y + 85, width: SignUpButton.frame.width, height: SignUpButton.frame.height)
        
        passwordField.frame = CGRect(x: passwordField.frame.origin.x, y: passwordField.frame.origin.y + 25, width: passwordField.frame.width, height: passwordField.frame.height)
        passwordBottom.frame = CGRect(x: passwordBottom.frame.origin.x, y: passwordBottom.frame.origin.y + 25, width: passwordBottom.frame.width, height: passwordBottom.frame.height)
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
