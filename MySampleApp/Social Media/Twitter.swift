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


class Tweet {
    
    var dateCreated : Date = "Fri Sep 9 6:38:00 +0000 2016".toDate()  // Format: Wed Aug 29 17:12:58 +0000 2012
    var isFavorite: Bool = false
    var id: String = ""
    var text: String = ""
    var retweetCount: Double = 0
    var containsSensitiveContent: Bool = false
    var nameOfCreator: String = ""
    var profileImageLinkOfCreator: String = ""
    var creatorIsVerified: Bool = false
    var usernameOfCreator: String = ""
    var favoritesCount: Double = 0
    var isARetweet: Bool = false
    var in_reply_to_username: String? = nil
    var isAReply: Bool = false
    
    
    
    init(tweetJSON: JSON) {
        
        
        
        // Check if it's a Retweet
        if tweetJSON["retweeted"].bool! {
            // It's a retweet
            self.isARetweet = true
            self.isAReply = false
            self.in_reply_to_username = nil
            
            // Get the Retweeted JSON
            let retweetJSON = tweetJSON["retweeted_status"]
            
            self.isFavorite = retweetJSON["favorited"].bool!
            self.retweetCount = retweetJSON["retweet_count"].double!
            self.dateCreated =  retweetJSON["created_at"].string!.toDate()
            self.text = retweetJSON["text"].string!
            self.id = retweetJSON["id_str"].string!
            self.favoritesCount = retweetJSON["favorite_count"].double!
            
            // Creator Information
            let userJSON = retweetJSON["user"]
            
            self.profileImageLinkOfCreator = userJSON["profile_image_url_https"].string!
            self.creatorIsVerified = userJSON["verified"].bool!
            self.nameOfCreator = userJSON["name"].string!
            self.usernameOfCreator = userJSON["screen_name"].string!
            
            
        }
            
            
            
        else{
            // It is not a retweet
            self.isARetweet = false
            self.isAReply = false
            self.in_reply_to_username = nil
            
            
            
            self.isFavorite = tweetJSON["favorited"].bool!
            self.retweetCount = tweetJSON["retweet_count"].double!
            self.dateCreated =  tweetJSON["created_at"].string!.toDate()
            self.text = tweetJSON["text"].string!
            self.id = tweetJSON["id_str"].string!
            self.favoritesCount = tweetJSON["favorite_count"].double!
            
            // Creator Information
            let userJSON = tweetJSON["user"]
            
            self.profileImageLinkOfCreator = userJSON["profile_image_url_https"].string!
            self.creatorIsVerified = userJSON["verified"].bool!
            self.nameOfCreator = userJSON["name"].string!
            self.usernameOfCreator = userJSON["screen_name"].string!
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
}

