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

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var SignInButton: UIButton!
    @IBOutlet var SignUpButton: UIButton!
    
    var blackOverlay: UIImageView?
    var loadingSymbol: UIImageView?
    /// This variable should be located in whatever view controller is used to sign in
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
      
        //loading
        let loadingOverlay = ShowLoadingOverlay()
        
        blackOverlay = loadingOverlay.showBlackOverlay()
        loadingSymbol = loadingOverlay.showLoadingSymbol()
        
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
