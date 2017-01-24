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
import TwitterKit


/// - TODO: Document

func authorizeTwitter(onViewController: UIViewController,  completion: @escaping (_ loginError: AuthorizationError?) -> () ) {
    
    
    
    Twitter.sharedInstance().logIn(withMethods: .all, completion: {  (session, error) in
        
        if let session = session{
            
            let token = session.authToken
            let secret = session.authTokenSecret
            
            saveTwitterAccount(withToken: token, andSecret: secret)
        }
        
        if let error = error{
            completion(AuthorizationError.Unknown)
        } else{
            completion(nil)
        }
        
        
    })
    
}







    
