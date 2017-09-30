//
//  Tweet.swift
//  Swap
//
//  Created by Micheal S. Bingham on 1/15/17.
//
//
import Foundation
//import RealmSwift
import Swifter

/*
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
    dynamic var isAReply: Bool = false
    
    
}

func returnTweet(fromJSON: SwifteriOS.JSON) -> Tweet {
    
    let tweet = Tweet()
    
    
    
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


func returnTweets(fromJSON: SwifteriOS.JSON) -> List<Tweet>? {
    
    
    if let tweetJsons = fromJSON.array{
        let allTweets: List<Tweet> =  List<Tweet>()
        
        
        for json in tweetJsons {
            
            allTweets.append(returnTweet(fromJSON: json))
            
        }
        
        return allTweets
        
    } else{
        
        return nil
    }
    
    
    
    
}
 */
