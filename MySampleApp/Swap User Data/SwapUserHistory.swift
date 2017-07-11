//
//  SwapUserHistory.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/21/16.
//
//
import Foundation
import AWSDynamoDB


class SwapUserHistory{
    
    /// The user who commits the Swap action
    var swap: String
    
    /// THe user who gets swapped
    var swapped: String
    
    /// Object refers to NoSQL database of users
    var NoSQL = AWSDynamoDBObjectMapper.default()
    
    /// Variable used to modify how data is stored in database
    var updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
    
    var currentTime = NSDate().timeIntervalSince1970 as NSNumber
    
    /// Creates a Swap User History Object with the swap and swapped usernames as partition and sort keys and automatically sets the time swapped in the Database
    init(swap: String = getUsernameOfSignedInUser(), swapped: String) {
        
        self.swap = swap
        self.swapped = swapped
        
    }
    
    
    func didShare(BirthdayIs: Bool? = nil,
                  EmailIs: Bool? = nil,
                  VineIs: Bool? = nil,
                  PhonenumberIs: Bool? = nil,
                  SpotifyIs: Bool? = nil,
                  RedditIs: Bool? = nil,
                  TwitterIs: Bool? = nil,
                  YouTubeIs: Bool? = nil,
                  SoundCloudIs: Bool? = nil,
                  PinterestIs: Bool? = nil,
                  InstagramIs: Bool? = nil,
                  GitHubIs: Bool? = nil,
                  VimeoIs: Bool? = nil,
                  didGivePoints: Bool? = nil,
                  latitude: String? = nil,
                  longitude: String? = nil,
                  completion: @escaping (_ error: Error?) -> Void = {noError in return})  {
        
        
        // Ensures that if a value is not passed in the function, it is ignored when saved into database
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
        /// Swap History Object for database
        let swapHistory = SwapHistory()
        
        // Each Swap History Row/Object in Database is identified by the person who swapped, 'swap' and the person that is swapped 'swapped'
        swapHistory?._swap = self.swap
        swapHistory?._swapped = self.swapped
        swapHistory?._time = currentTime
        
     
        
        swapHistory?._didShareBirthday = (BirthdayIs != nil) ? (BirthdayIs! as NSNumber) : nil
        swapHistory?._didShareEmail = (EmailIs != nil) ? (EmailIs! as NSNumber) : nil
        swapHistory?._didShareVine = (VineIs != nil) ? (VineIs! as NSNumber) : nil
        swapHistory?._didSharePhonenumber = (PhonenumberIs != nil) ? (PhonenumberIs! as NSNumber) : nil
        swapHistory?._didShareSpotify = (SpotifyIs != nil) ? (SpotifyIs! as NSNumber) : nil
        swapHistory?._didShareReddit = (RedditIs != nil) ? (RedditIs! as NSNumber) : nil
        swapHistory?._didShareTwitter = (TwitterIs != nil) ? (TwitterIs! as NSNumber) : nil
        swapHistory?._didShareYouTube = (YouTubeIs != nil) ? (YouTubeIs! as NSNumber) : nil
        swapHistory?._didShareSoundCloud = (SoundCloudIs != nil) ? (SoundCloudIs! as NSNumber) : nil
        swapHistory?._didSharePinterest = (PinterestIs != nil) ? (PinterestIs! as NSNumber) : nil
        swapHistory?._didShareInstagram = (InstagramIs != nil) ? (InstagramIs! as NSNumber) : nil
        swapHistory?._didShareGitHub = (GitHubIs != nil) ? (GitHubIs! as NSNumber) : nil
        swapHistory?._didShareVimeo = (VimeoIs != nil) ? (VimeoIs! as NSNumber) : nil
        swapHistory?._didGiveSwapPointsFromSwap = (didGivePoints != nil) ? (didGivePoints! as NSNumber) : nil
        swapHistory?._latitude = (latitude != nil) ? latitude! : nil
        swapHistory?._longitude = (longitude != nil) ? longitude! : nil
        
        NoSQL.save(swapHistory!, configuration: updateMapperConfig, completionHandler: { error in
            
            completion(error)
            
        })
        
    }
    
}
