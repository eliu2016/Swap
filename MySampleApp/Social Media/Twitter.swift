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
    
    logoutTwitter()
    
    Twitter.sharedInstance().logIn(withMethods: .all, completion: {  (session, error) in
        
        if let session = session{
            
            let token = session.authToken
            let secret = session.authTokenSecret
      
            
            saveTwitterAccount(withToken: token, andSecret: secret)
           
            
            if error != nil{
                completion(AuthorizationError.Unknown)
            } else{
              
                let twitterAccount = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET, oauthToken: getTwitterToken()!, oauthTokenSecret: getTwitterSecret()!)

                twitterAccount.getTimeline(for: session.userName, success: { (json) in
                    
                    print("\n\n\n\n\n\n\n\n the twitter json is ... \(json)")
                    let image = json.array?[0]["user"]["profile_image_url_https"].string ?? defaultImage
                    saveTwitterPhoto(withLink: image)
                    
                    SwapUser(username: getUsernameOfSignedInUser()).set(TwitterID: session.userID, DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            
                            completion(nil)
                        }
                        
                    })
                    
                    
                })
                
                
            
            }
            
        }
        
      
        
        
    })
    
}







    
