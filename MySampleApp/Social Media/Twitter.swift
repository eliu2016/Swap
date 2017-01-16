//
//  Twitter.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/23/16.
//
//

import Foundation
import Social
import Accounts
import SwifteriOS
import SafariServices



/// DON'T USE YET


func authorizeTwitter(onViewController: UIViewController,  completion: @escaping (_ loginError: AuthorizationError?) -> () ) {
    
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
    
    
    // Prompt the user for permission to their twitter account stored in the phone's settings
    accountStore.requestAccessToAccounts(with: accountType, options: nil) {
        granted, error in
        
        if !granted {
            
            // Access to Twitter has not been granted
            
            completion(AuthorizationError.Cancelled)
            
        }
            
        else {
            
            // Access to Twitter Account HAS been granted
            
            
            let accounts = accountStore.accounts(with: accountType) as! [ACAccount]
            
            guard !accounts.isEmpty else {
                
                // There are no Twitter Accounts in the System 
                // Maybe Tell the user that there are no Twitter Acccounts in the System?
                
                completion(AuthorizationError.Cancelled)
                return
                
            }
            
           
            
            
            var swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
            
            swifter.authorize(with: URL(string: "fb957571477682705://")!, presentFrom: onViewController, success: { (cred, response) in
                
                // Did succeed in Authorizing Twitter 
                // Save Key and Secret in Keychain so that we can Authorize it Later 
                saveTwitterAccount(withConsumerKey: (cred?.key)!, andSecret: (cred?.secret)!)
                
                
              saveTwitterPhoto(withLink: "https://twitter.com/\((cred?.screenName)!)/profile_image?size=original")
                
             
               
                
                // Set the Twitter ID in Database 
                SwapUser(username: getUsernameOfSignedInUser()).set(TwitterID: cred?.userID!, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        
                        completion(nil)
                    }
                 
                    
                    
                    return nil
                
                }, CannotSetInformation: { 
                    
                    completion(AuthorizationError.Unknown)
                })
                
                
                
                
                
            }, failure: { (error) in
                
                
                
                completion(AuthorizationError.Unknown)
            })
            
           
        }
        
    }
    
}



    
    
    
    
    


