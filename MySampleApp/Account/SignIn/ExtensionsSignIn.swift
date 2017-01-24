//
//  ExtensionsSignIn.swift
//  Swap
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.6
//
//

import Foundation
import AWSCognitoIdentityProvider
import AWSMobileHubHelper
import AWSDynamoDB
import OneSignal
/// Extension for the View Controller containing the UI to sign in the user. These functions aid in the signing in process.
@available(iOS 9.0, *)
extension SignInViewController {
    
    /// Call this function whenever the sign in button is pressed to log in the user
    /// - Attention: This function does not itself sign in the user but rather calls other functions that sign in the user
    
    func signIn() {
        // set the interactive auth delegate to self, since this view controller handles the login process for user pools
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(AWSCognitoUserPoolsSignInProvider.sharedInstance())
    }
    
    /// Edit this function in order to customize what happens after the user signs in successfully (i.e. Display Profile View Controller
    func handleLoginWithSignInProvider(_ signInProvider: AWSSignInProvider) {
        
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider, completionHandler: {(result, error)  in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            
            if error == nil {
                DispatchQueue.main.async(execute: {
                    
                    // Do whatever needs to be done after a succesful login (i.e. go to profile view controller)
                    Analytics.didSignIn()
                    SwapUser(username: getUsernameOfSignedInUser()).setUpPushNotifications()
                    self.performSegue(withIdentifier: "signIn", sender: nil)
                    
                    
                    
                })
            }
            
            
            print("RESULT = \(result), error = \(error)")
            
        })
    }
    
    
    
    
}

// Extension to adopt the `AWSCognitoIdentityInteractiveAuthenticationDelegate` protocol
@available(iOS 9.0, *)
extension SignInViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    // this function handles the UI setup for initial login screen, in our case, since we are already on the login screen, we just return the View Controller instance
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }
    
    
}

// Extension to adopt the `AWSCognitoIdentityPasswordAuthentication` protocol
@available(iOS 9.0, *)
extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {
    /**
     Obtain username and password from end user.
     @param authenticationInput input details including last known username
     @param passwordAuthenticationCompletionSource set passwordAuthenticationCompletionSource.result
     with the username and password received from the end user.
     */
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        
        self.passwordAuthenticationCompletion = (passwordAuthenticationCompletionSource as AnyObject) as? AWSTaskCompletionSource<AnyObject>
        
    }
    
    
    /// Customize this function in order to display UI or do whatever that needs to be done if the login fails for the user (i.e. Display UI screen that says invalid login)
    func didCompleteStepWithError(_ error: Error?) {
        if let error = error {
            
            //*** There was an error signing in
            
            DispatchQueue.main.async(execute: {
                
              
                self.signInFailed()
                
                UIAlertView(title: "Could Not Sign In",
                            message: "Invalid username and password",
                            delegate: nil,
                            cancelButtonTitle: "Ok").show()
            })
        }
    }
}

// Extension to adopt the `AWSCognitoUserPoolsSignInHandler` protocol
@available(iOS 9.0, *)
extension SignInViewController: AWSCognitoUserPoolsSignInHandler {
    
    /// Edit this function in order to customize what happens if the user does 'NOT' enter a username and password at sign in.
    func handleUserPoolSignInFlowStart() {
        // check if both username and password fields are provided
        guard let username = self.usernameField.text?.lowercased(), !username.isEmpty,
            let password = self.passwordField.text, !password.isEmpty else {
                DispatchQueue.main.async(execute: {
                    
                    self.signInFailed()
                    
                    UIAlertView(title: "Invalid Login",
                                message: "Please enter a valid username and password.",
                                delegate: nil,
                                cancelButtonTitle: "Ok").show()
                })
                return
        }
        // set the task completion result as an object of AWSCognitoIdentityPasswordAuthenticationDetails with username and password that the app user provides
        self.passwordAuthenticationCompletion?.setResult(AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password))
    }
    
    func signInFailed(){
        
        blackOverlay?.isHidden = true
        loadingSymbol?.isHidden = true
        SignUpButton.isEnabled = true
        SignInButton.isEnabled = true
        usernameField.isEnabled = true
        passwordField.isEnabled = true
        
    }
}









//********************************************************************************************************************************************
//============================================================================================================================================
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++









/// Extension for the View Controller containing the UI to sign in the user. These functions aid in the signing in process.
@available(iOS 9.0, *)
extension ConfirmAccountViewController {
    
    /// Call this function whenever the sign in button is pressed to log in the user
    /// - Attention: This function does not itself sign in the user but rather calls other functions that sign in the user
    
    func signIn() {
        // set the interactive auth delegate to self, since this view controller handles the login process for user pools
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(AWSCognitoUserPoolsSignInProvider.sharedInstance())
    }
    
    /// Edit this function in order to customize what happens after the user signs in successfully (i.e. Display Profile View Controller
    func handleLoginWithSignInProvider(_ signInProvider: AWSSignInProvider) {
        
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider, completionHandler: {(result, error)  in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            
            if error == nil {
                DispatchQueue.main.async(execute: {
                    
                    // Do whatever needs to be done after a succesful login (i.e. go to profile view controller)
                    
                    // Register User For Push Notifications
                    OneSignal.registerForPushNotifications()
                    
                    self.performSegue(withIdentifier: "toSetProfileViewController", sender: nil)
                    
                    
                    
                })
            }
            
            
            print("RESULT = \(result), error = \(error)")
            
        })
    }
    
    
    
    
}

// Extension to adopt the `AWSCognitoIdentityInteractiveAuthenticationDelegate` protocol
@available(iOS 9.0, *)
extension ConfirmAccountViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    // this function handles the UI setup for initial login screen, in our case, since we are already on the login screen, we just return the View Controller instance
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }
    
    
}

// Extension to adopt the `AWSCognitoIdentityPasswordAuthentication` protocol
@available(iOS 9.0, *)
extension ConfirmAccountViewController: AWSCognitoIdentityPasswordAuthentication {
    /**
     Obtain username and password from end user.
     @param authenticationInput input details including last known username
     @param passwordAuthenticationCompletionSource set passwordAuthenticationCompletionSource.result
     with the username and password received from the end user.
     */
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        
        self.passwordAuthenticationCompletion = (passwordAuthenticationCompletionSource as AnyObject) as? AWSTaskCompletionSource<AnyObject>
        
    }
    
    
    /// Customize this function in order to display UI or do whatever that needs to be done if the login fails for the user (i.e. Display UI screen that says invalid login)
    func didCompleteStepWithError(_ error: Error?) {
        if let error = error {
            
            //*** There was an error signing in
            
            DispatchQueue.main.async(execute: {
                
                
                UIAlertView(title: "Could Not Sign In",
                            message: "Invalid username and password",
                            delegate: nil,
                            cancelButtonTitle: "Ok").show()
            })
        }
    }
}

// Extension to adopt the `AWSCognitoUserPoolsSignInHandler` protocol
@available(iOS 9.0, *)
extension ConfirmAccountViewController: AWSCognitoUserPoolsSignInHandler {
    
    /// Edit this function in order to customize what happens if the user does 'NOT' enter a username and password at sign in.
    func handleUserPoolSignInFlowStart() {
   
      
        // set the task completion result as an object of AWSCognitoIdentityPasswordAuthenticationDetails with username and password that the app user provides
        self.passwordAuthenticationCompletion?.setResult(AWSCognitoIdentityPasswordAuthenticationDetails(username: getSavedUsername()!, password: getSavedPassword()!))
    }
}








