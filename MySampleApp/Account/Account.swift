//
//  Account.swift
//  Swap
// This file handles creating, resetting, etc a Swap Account
//  Created by Micheal S. Bingham on 11/19/16.
//  Copyright © 2016 Swap Inc. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognitoIdentityProvider
import AWSMobileHubHelper
import Alamofire
import SwiftyJSON

/// Function to create an account for a Swap User.
/// - author: Micheal S. Bingham
/// - todo: Find more errors that can result in signing up
/// - version: 2.0
/// - Parameters:
///   - username: Entered username
///   - password: Entered password
///   - email: Entered email address
///   - phonenumber: Entered phone number
///   - toPool: AWSCognitioIdenity Pool Object to add this user to, by default it is the pool declared in constants
///   - failedToCreateAccount: Completion block executed with 'SignUpError' passed in it if there is an error creating an account
///   - signUpError: .EmptyFields .PasswordTooShort .UsernameTaken .InvalidUsername .InvalidPhonenumber .InvalidEmail .UnknownSignUpError
///   - didCreateAccount: Code block executed if succeded creating an account
///   - todo: Find more errors that can result in signing up
func createAccount(username: String?,
                   password: String?,
                   email: String?,
                   phonenumber: String?,
                   toPool: AWSCognitoIdentityUserPool = pool,
                   failedToCreateAccount: @escaping (_ signUpError: SignUpError) -> Void,
                   didCreateAccount: @escaping () -> Void)  {
    
    
    // Ensures that the entered parameters are not empty
    
    guard !(username?.isEmpty)! && !(password?.isEmpty)! && !(email?.isEmpty)! && !(phonenumber?.isEmpty)! else{
        
        let signUpError = SignUpError.EmptyFields
        
        // Error is passed in completion block 'failedToCreateAccount'
        failedToCreateAccount(signUpError)
        
        
        return
    }
    
   
    guard (username?.isAValidUsername())! else {
        
        
        failedToCreateAccount(SignUpError.InvalidUsername)
        
        
        return
    }
    
    
    // Ensures Password is long enough
    
    guard (password?.characters.count)! >= 6 else{
        
        
        
        failedToCreateAccount(SignUpError.PasswordTooShort)
        
        return
    }
    
    
    
    
    let Phone = AWSCognitoIdentityUserAttributeType()
    let Email = AWSCognitoIdentityUserAttributeType()
    let ProfilePictureURL = AWSCognitoIdentityUserAttributeType()
    let IsVerified = AWSCognitoIdentityUserAttributeType()
    
    Phone?.name = "phone_number"
    Email?.name = "email"
    Email?.value = email!.lowercased().trim()
    Phone?.value = phonenumber!
    
    ProfilePictureURL?.name = "picture"
    ProfilePictureURL?.value = defaultImage
    
    IsVerified?.name = "profile"
    IsVerified?.value = "IS_NOT_VERIFIED"
    
    
    
    
    
    // Adds user to user pool in backend
    
    
    
    toPool.signUp(username!.lowercased().trim(), password: password!, userAttributes: [Phone!, Email!, ProfilePictureURL!, IsVerified!], validationData: nil).continue(with: AWSExecutor.mainThread(), with: { (task)  in
        
        print("inside sign up")
        
        
        if let error = task.error as? NSError{
            
            // There was an error signing up
            print("The sign up error is \(error.debugDescription)")
            
            let errorString = error.debugDescription
            
            
            if errorString.contains("UsernameExistsException"){
                failedToCreateAccount(SignUpError.UsernameTaken)
            }
                
            else if errorString.contains("Invalid phone number format"){
                
                failedToCreateAccount(SignUpError.InvalidPhonenumber)
            }
                
            else if errorString.contains("Invalid email address format"){
                failedToCreateAccount(SignUpError.InvalidEmail)
            }
                
            else if errorString.contains("Invalid email address format"){
                failedToCreateAccount(SignUpError.InvalidEmail)
            }
                
            else if errorString.contains("Value at 'username' failed to satisfy constraint"){
                failedToCreateAccount(SignUpError.InvalidUsername)
            }
                
            else{
                
                //Unknown Error that hasn't been handled
                failedToCreateAccount(SignUpError.UnknownSignUpError)
                
            }
            
            
            
        }
        
        if task.result != nil{
            
            getContact(withPhonenumber: phonenumber!)
            
            // Succeeded in signing up user
            print("Succeeded in Signing Up User")
            
            // Saves the username and password in nsuserdefaults so you can retreive it in another view controller
            saveUsername(username: username?.trim().lowercased())
            savePassword(password: password!)
            saveEmail(email: email?.lowercased().trim())
            savePhonenumber(phone: phonenumber?.trim())

            
            didCreateAccount()
            
        }
        
        
        
        
        
        return nil
    })
    
    
}


///
/// Function that resends confirmation code to user with specified username
/// - Author: Micheal S. Bingham
/// - Parameter toUserWithUsername: Username that belongs to the user to send code to
func resendConfirmationCode(toUserWithUsername: String, inPool: AWSCognitoIdentityUserPool? = pool){
    inPool?.getUser(toUserWithUsername.lowercased()).resendConfirmationCode()
    
}


/// Function to confirm user with the verification number sent to their phonenumber
/// - Author: Micheal S. Bingham
/// - Parameters:
///   - inPool: AWSCognitioIdentityUserPool object that the user is located in, by default it is the pool declared in constants
///   - withCode: Optional String that the user entered in as the confirmation code
///   - username: Username of the user that needs to be confirmed
///   - failed: Code block executed if failed (invalid code or empty string - user did not enter confirmation code)
///   - succeded: Code block executed if succeeded
func confirmUser(inPool: AWSCognitoIdentityUserPool? = pool,  withCode: String?, username: String, failed: @escaping () -> Void, succeded: @escaping ()-> Void)  {
    
    guard  withCode != nil else{
        // String is nil
        failed()
        return
    }
    
    guard !(withCode?.isEmpty)! else{
        // Empty String
        
        failed()
        
        return
    }
    
    // Confirms User Account
    inPool?.getUser(username.lowercased()).confirmSignUp(withCode!, forceAliasCreation: true).continue(with: AWSExecutor.mainThread(), with: { (task) -> Any? in
        
        
        if task.error != nil {
            
            // There was an error
            // Possibly Wrong Code
            
            failed()
            
        } else {
            
            // Correct Code
            succeded()
        }
        
        return nil
    })
    
    
}


/// Function that returns whether user is signed in or not
///
/// - Returns: If user is signed in
func isSignedIn() -> Bool {
    
    
    return AWSIdentityManager.defaultIdentityManager().isLoggedIn
    
    
}




/// Function to sign out of Swap.
///
/// - Parameter didSignOut: This optional completion block is executed whenever there is a successful sign out
func signOut(didSignOut: @escaping () -> Void?  = {return} )  {
    
    SwapUser(username: getUsernameOfSignedInUser()).removePushNotificationID()
    
    AWSIdentityManager.defaultIdentityManager().logout { (result, error) in
        
        
        // successful sign in
        print("Sign out")
        didSignOut()
        
    }
}


/// Gets the username of the Swap User that is currently signed in
///
/// - Returns: Username of signed in user
func getUsernameOfSignedInUser() -> String {
    
    if let username = AWSIdentityManager.defaultIdentityManager().userName{
    
        return username
    }  else{
        
        return getSavedUsername()!
    }
    
}



/// Predicts user's gender based on first name and stores their gender in database on a background thread
///
/// - Parameter withFirstname: Firstname of the user
func guessAndSetSex(withFirstname: String) {
    
    DispatchQueue.global(qos: .default).async {
        
        Alamofire.request(URL(string: "https://api.genderize.io/")!, method: .get, parameters: ["name": "\(withFirstname)"]).responseJSON { (response) in
            
            
            if let data = response.data{
                
                let json = JSON(data: data)
                
                print("the json is ..... \(json)")
                if let gender = json["gender"].string{
                    
                    SwapUser(username: getUsernameOfSignedInUser()).set(Gender: gender)
                }
            }
        }
        
        
    }
}


