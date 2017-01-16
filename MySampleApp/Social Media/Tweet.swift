//
//  Tweet.swift
//  Swap
//
//  Created by Micheal S. Bingham on 1/15/17.
//
//

import Foundation
import RealmSwift
import SwifteriOS

class Tweet: Object {
    
    
    
    dynamic var dateCreated : Date = "Fri Sep 9 6:38:00 +0000 2016".toDate()  // Format: Wed Aug 29 17:12:58 +0000 2012
    dynamic var isFavorite: Bool = false
    dynamic var id: String = ""
    dynamic var text: String = ""
    dynamic var retweetCount: Double = 0
    dynamic var containsSensitiveContent: Bool = false
    dynamic var nameOfCreator: String = ""
    dynamic var profileImageLinkOfCreator: String = ""
    dynamic var creatorIsVerified: Bool = false
    dynamic var usernameOfCreator: String = ""
    dynamic var favoritesCount: Double = 0
    dynamic var isARetweet: Bool = false
    dynamic  var isAReply: Bool = false
    /*
     init(tweetJSON: JSON){
        
            
            
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
    */
    
    
}

func returnTweet(fromJSON: SwifteriOS.JSON) -> Tweet {
    
        var tweet = Tweet()
        
        
        
        // Check if it's a Retweet
        if fromJSON["retweeted"].bool! {
            // It's a retweet
            tweet.isARetweet = true
            tweet.isAReply = false
            
            
            // Get the Retweeted JSON
            let retweetJSON = fromJSON["retweeted_status"]
            
            tweet.isFavorite = retweetJSON["favorited"].bool!
            tweet.retweetCount = retweetJSON["retweet_count"].double!
            tweet.dateCreated =  retweetJSON["created_at"].string!.toDate()
            tweet.text = retweetJSON["text"].string!
            tweet.id = retweetJSON["id_str"].string!
            tweet.favoritesCount = retweetJSON["favorite_count"].double!
            
            // Creator Information
            let userJSON = retweetJSON["user"]
            
            tweet.profileImageLinkOfCreator = userJSON["profile_image_url_https"].string!
            tweet.creatorIsVerified = userJSON["verified"].bool!
            tweet.nameOfCreator = userJSON["name"].string!
            tweet.usernameOfCreator = userJSON["screen_name"].string!
            
            
        }
            
            
            
        else{
            // It is not a retweet
            tweet.isARetweet = false
            tweet.isAReply = false
        
            
            
            
            tweet.isFavorite = fromJSON["favorited"].bool!
            tweet.retweetCount = fromJSON["retweet_count"].double!
            tweet.dateCreated =  fromJSON["created_at"].string!.toDate()
            tweet.text = fromJSON["text"].string!
            tweet.id = fromJSON["id_str"].string!
            tweet.favoritesCount = fromJSON["favorite_count"].double!
            
            // Creator Information
            let userJSON = fromJSON["user"]
            
            tweet.profileImageLinkOfCreator = userJSON["profile_image_url_https"].string!
            tweet.creatorIsVerified = userJSON["verified"].bool!
            tweet.nameOfCreator = userJSON["name"].string!
            tweet.usernameOfCreator = userJSON["screen_name"].string!
            
            
            
            
            
        }
        
        
        return tweet
        
    
    
}
