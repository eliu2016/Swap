//
//  SwapUser.swift
//  Swap
//
//  Created by Micheal S. Bingham on 11/19/16.
//  Copyright © 2016 Swap Inc. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSCognitoIdentityProvider
import AWSCore
import AWSMobileHubHelper
import OneSignal

/// Class for a SwapUser object
class SwapUser {
    
    /// Username identifies users in database
    var username: String
    
    /// Object refers to NoSQL database of users
    var NoSQL = AWSDynamoDBObjectMapper.default()
    
    /// Variable used to modify how data is stored in database
    var updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
    
    /// Variable to determine if user is verified 
    var isVerified = false
    
    // Variable containing profile picture URL
    var profilePictureURL: URL = URL(string: defaultImage)!
    
    var dynamoDB = AWSDynamoDB(forKey: "USEast1DynamoDBProvider")
    
    
    
    /// Whenever a SwapUser object is created, unless otherwise specified in parameters, the object assumes it is referring to the current swap user
    init(username: String = getUsernameOfSignedInUser(), isVerified: Bool = false, picture: URL = URL(string: defaultImage)!) {
        
        self.username = username
        self.profilePictureURL = picture
        self.isVerified = isVerified
        
        
    }
    
    
    
    
    /// Function to set a swap user's data and save it. Only pass whatever attribute(s) to save in database in this function, not all attributes have to be passed. For example, if you only want to set the lastname of a user without modifying any other attribute, call swapUserObject.set(Lastname: "LastnameValue"); however, if you would like to set firstname and lastname, call swapUserObject.set(Firstname: "Micheal", Lastname: "Bingham") where swapUserObject is an object of type 'SwapUser' that has been initalized with the username of the user.
    /// - author: Micheal S. Bingham
    /// - version: 2.0
    /// - Parameters:
    ///   - DidSetInformation: Optional completion block called when there is a success in saving the information
    ///   - CannotSetInformation: Optional completion block called when there is a failure in saving the information
    
    
    func set( Firstname: String? = nil,
              Middlename: String? = nil,
              Lastname: String? = nil,
              Phonenumber: String? = nil,
              Email: String? = nil,
              Website: String? = nil,
              Company: String? = nil,
              Bio: String? = nil,
              Birthday: Double? = nil,
              Gender: String? = nil,
              Date_Created: Double? = nil,
              isVerified: Bool? = nil,
              isPrivate: Bool? = nil,
              Points: Int? = nil,
              Swapped: Int? = nil,
              Swaps: Int? = nil,
              ProfileImage: String? = nil,
              QRImage: String? = nil,
              SpotifyID: String? = nil,
              YouTubeID: String? = nil,
              VineID: String? = nil,
              InstagramID: String? = nil,
              TwitterID: String? = nil,
              SnapchatID: String? = nil,
              PinterestID: String? = nil,
              SoundCloudID: String? = nil,
              WillShareSpotify: Bool? = nil,
              WillShareYouTube: Bool? = nil,
              WillSharePhonenumber: Bool? = nil,
              WillShareVine: Bool? = nil,
              WillShareInstagram: Bool? = nil,
              WillShareTwitter: Bool? = nil,
              WillShareEmail: Bool? = nil,
              WillShareSnapchat: Bool? = nil,
              WillSharePinterest: Bool? = nil,
              WillShareSoundCloud: Bool? = nil,
              DidSetInformation: @escaping () -> Void? = { return nil },
              CannotSetInformation: @escaping () -> Void? =  { return }) {
        
        // Ensures that if a value is not passed in the function, it is ignored when saved into database
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
        // Creates an 'Users' object in order to store to database
        let user = Users()
        user?._username = self.username
        
        user?._firstname = (Firstname != nil && !((Firstname?.isEmpty)!)) ? Firstname?.trim(): nil
        user?._middlename = (Middlename != nil && !((Middlename?.isEmpty)!)) ? Middlename?.trim(): nil
        user?._lastname = (Lastname != nil && !((Lastname?.isEmpty)!)) ? Lastname?.trim(): nil
        user?._phonenumber = (Phonenumber != nil && !((Phonenumber?.isEmpty)!)) ? Phonenumber?.trim(): nil
        user?._email = (Email != nil && !((Email?.isEmpty)!)) ? Email?.trim(): nil
        user?._website = (Website != nil && !((Website?.isEmpty)!)) ? Website?.trim(): nil
        user?._birthday = (Birthday != nil) ? (Birthday! as NSNumber) : nil
        user?._company = (Company != nil && !((Company?.isEmpty)!)) ? Company?.trim(): nil
        user?._bio = (Bio != nil && !((Bio?.isEmpty)!)) ? Bio?.trim(): nil
        user?._gender =  (Gender != nil && !((Gender?.isEmpty)!)) ? Gender: nil
        user?._isVerified = (isVerified != nil) ? (isVerified! as NSNumber) : nil
        user?._dateCreated = (Date_Created != nil) ? (Date_Created! as NSNumber) : nil
        user?._isPrivate = (isPrivate != nil) ? (isPrivate! as NSNumber) : nil
        user?._points = (Points != nil) ? (Points! as NSNumber) : nil
        user?._swapped = (Swapped != nil) ? (Swapped! as NSNumber) : nil
        user?._swaps = (Swaps != nil) ? (Swaps! as NSNumber) : nil
        user?._profilePictureUrl = (ProfileImage != nil && !((ProfileImage?.isEmpty)!)) ? ProfileImage: nil
        user?._swapCodeUrl = (QRImage != nil && !((QRImage?.isEmpty)!)) ? QRImage: nil
        user?._spotifyID = (SpotifyID != nil && !((SpotifyID?.isEmpty)!)) ? SpotifyID: nil
        user?._youtubeID = (YouTubeID != nil && !((YouTubeID?.isEmpty)!)) ? YouTubeID: nil
        user?._vineID = (VineID != nil && !((VineID?.isEmpty)!)) ? VineID: nil
        user?._instagramID = (InstagramID != nil && !((InstagramID?.isEmpty)!)) ? InstagramID: nil
        user?._twitterID = (TwitterID != nil && !((TwitterID?.isEmpty)!)) ? TwitterID: nil
        user?._snapchatID = (SnapchatID != nil && !((SnapchatID?.isEmpty)!)) ? SnapchatID: nil
        user?._pinterestID = (PinterestID != nil && !((PinterestID?.isEmpty)!)) ? PinterestID: nil
        user?._soundcloudID = (SoundCloudID != nil && !((SoundCloudID?.isEmpty)!)) ? SoundCloudID: nil
        user?._willShareSpotify = (WillShareSpotify != nil) ? (WillShareSpotify! as NSNumber) : nil
        user?._willShareYouTube = (WillShareYouTube != nil) ? (WillShareYouTube! as NSNumber) : nil
        user?._willSharePhone = (WillSharePhonenumber != nil) ? (WillSharePhonenumber! as NSNumber) : nil
        user?._willShareVine = (WillShareVine != nil) ? (WillShareVine! as NSNumber) : nil
        user?._willShareInstagram = (WillShareInstagram != nil) ? (WillShareInstagram! as NSNumber) : nil
        user?._willShareTwitter = (WillShareTwitter != nil) ? (WillShareTwitter! as NSNumber) : nil
        user?._willShareEmail = (WillShareEmail != nil) ? (WillShareEmail! as NSNumber) : nil
        user?._willShareSnapchat = (WillShareSnapchat != nil) ? (WillShareSnapchat! as NSNumber) : nil
        user?._willSharePinterest = (WillSharePinterest != nil) ? (WillSharePinterest! as NSNumber) : nil
        user?._willShareSoundCloud = (WillShareSoundCloud != nil) ? (WillShareSoundCloud! as NSNumber) : nil
        
        
        if let linkToProfileImage = ProfileImage{
            // User setted Profile Picture so we have to set it in amazon cognito 
            
            

            let ProfilePictureURL = AWSCognitoIdentityUserAttributeType()
            ProfilePictureURL?.name = "picture"
            ProfilePictureURL?.value = linkToProfileImage

            
            
            
            pool.getUser(self.username).update([ProfilePictureURL!])
        }
        
        
        NoSQL.save(user!, configuration: updateMapperConfig, completionHandler: { error in
            
            if error != nil{
                
                print("Can set information")
                CannotSetInformation()
            }
                
            else{
                
                
                
                DidSetInformation()
                
            }
            
            
        })
        
        
    }
    
    
    func getInformation(completion: @escaping (_ error: UserError?,  _ userData: Users? ) -> Void) {
        
        
        
        
        
        // Configures so that most recent data is obtained from NoSQL
        let  config = AWSDynamoDBObjectMapperConfiguration()
        config.consistentRead = true
        
        
        self.NoSQL.load(Users.self, hashKey: self.username, rangeKey: nil, configuration: config, completionHandler: { (user, error) in
            
            if error != nil {
                print("there was an error loading data..\nThe error is \(error.debugDescription)")
                let usererror: UserError = UserError.CouldNotGetUser
                completion(usererror, nil)
            }
                
            else{
                // There is no error
                
                if user != nil{
                    
                    let user = user as! Users
                    completion(nil, user)
                    
                } else{
                    
                    let usererror: UserError = UserError.CouldNotGetUser
                    completion(usererror, nil)
                }
                
                
                
            }
            
        })
        
        
        
        
        
        
    }
    
    
    /// Function that returns an array of SwapHistory objects for the users that Swapped this user.
    ///
    /// - Parameter result: Returns and Error and an array of SwapHistory objects. Error will be nil if  there is no error. Be sure to unwrap the swapHistory array. Iterate through swapHistories array to retrieve each individual SwapHistory object. See SwapHistory class for more information on a Swap History object. Each Swap History object has a property associated with the information it contains. For example: swapHistory._swapped is the person that was 'Swapped' and swapHistory.swap is the person that swapped. Each property also tells whether the specific social media were shared or not. It may be 'nil' or 'false' or 'true'. If swaphistory._didShareTwitter is nil or false , Twitter was not shared. It is more likely the value will be nil rather than false. If there are no records for Swap History, the array will be empty.
    func getSwappedHistory(result: @escaping (_ queryError: Error?, _ swappedHistories: [SwapHistory]? ) -> Void)  {
        
        // Configures so that most recent data is obtained from NoSQL
        let  config = AWSDynamoDBObjectMapperConfiguration()
        config.consistentRead = true
        
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.indexName = "swapped"
        queryExpression.keyConditionExpression = "#hashAttribute = :hashAttribute"
        queryExpression.expressionAttributeNames = ["#hashAttribute": "swapped"]
        queryExpression.expressionAttributeValues = [":hashAttribute": self.username]
        
        
        self.NoSQL.query(SwapHistory.self, expression: queryExpression, configuration: nil, completionHandler: { (output, error) in
            
            if error != nil{
                print("error querying ... \(error)")
                
                result(error, nil)
                
            }
                
            else{
                
                // Converts the response to an array of Swap History objects
                let swapHistories = output?.items as! [SwapHistory]
                result(nil, swapHistories)
                
                
                
                
            }
            
        })
        
        
    }
    
    
    /// Uploads a Profile Picture given the UIImage Data
    ///
    /// - Parameters:
    ///   - withData: Data representation of the image
    ///   - completion: If the error is nil, it has suceeded and the profile picture has been updated in Database
    func uploadProfilePicture(withData: Data, completion: @escaping (_ error: Error?) -> Void)  {
        
        let randomNumber = arc4random_uniform(99999999)
        
        
        let manager = AWSUserFileManager.defaultUserFileManager()
        let localContent = manager.localContent(with: withData, key: "public/\(self.username)/profile_picture-\(randomNumber).jpg")
       
        localContent.uploadWithPin(onCompletion: true,
                                   progressBlock: { (content, progress) in
                                    
                                    // Shows Progress
                                    
        }, completionHandler: { (content, error) in
            
            // Finished uploading
        if error == nil {
            
            
            
           let LinkToProfilePicture = "https://s3.amazonaws.com/swap-userfiles-mobilehub-1081613436/public/\(self.username)/profile_picture-\(randomNumber).jpg"
            
            self.set(ProfileImage: LinkToProfilePicture,DidSetInformation: {
                
                completion(nil)
                
                return nil
            })
            
            
        }
        else{
            
        completion(error)
        }
            
        })
        
    }
    
    
    
    /// Increments the 'swaps' value of a user. It increments by '1' by default if you do not pass anything as a parameter
    ///
    /// - Parameter byValue: 1 by default. It will decrement if you pass a negative number
    func incrementSwaps(byValue: NSNumber = 1)  {
        
      let username =  AWSDynamoDBAttributeValue()
        username?.s = self.username
        
        let value = AWSDynamoDBAttributeValue()
        value?.n = "\(byValue)"
        
        let updateItemInput = AWSDynamoDBUpdateItemInput()
        updateItemInput?.tableName = "swap-mobilehub-1081613436-Users"
        updateItemInput?.key = ["username": username!]
        updateItemInput?.updateExpression = "SET swaps = swaps + :val"
        updateItemInput?.expressionAttributeValues = [":val": value!]
        
        
       
        self.dynamoDB.updateItem(updateItemInput!, completionHandler: {(output, error) in
            
            
        })
        
        
        
    }
    
    func incrementSwapped(byValue: NSNumber = 1)  {
        
        let username =  AWSDynamoDBAttributeValue()
        username?.s = self.username
        
        let value = AWSDynamoDBAttributeValue()
        value?.n = "\(byValue)"
        
        let updateItemInput = AWSDynamoDBUpdateItemInput()
        updateItemInput?.tableName = "swap-mobilehub-1081613436-Users"
        updateItemInput?.key = ["username": username!]
        updateItemInput?.updateExpression = "SET swapped = swapped + :val"
        updateItemInput?.expressionAttributeValues = [":val": value!]
        
        
        
        self.dynamoDB.updateItem(updateItemInput!, completionHandler: {(output, error) in
            
            
        })
        
        
    }
    
    func incrementPoints(byValue: NSNumber = 1)  {
        
        let username =  AWSDynamoDBAttributeValue()
        username?.s = self.username
        
        let value = AWSDynamoDBAttributeValue()
        value?.n = "\(byValue)"
        
        let updateItemInput = AWSDynamoDBUpdateItemInput()
        updateItemInput?.tableName = "swap-mobilehub-1081613436-Users"
        updateItemInput?.key = ["username": username!]
        updateItemInput?.updateExpression = "SET points = points + :val"
        updateItemInput?.expressionAttributeValues = [":val": value!]
        
        
        
        self.dynamoDB.updateItem(updateItemInput!, completionHandler: {(output, error) in
            
            
        })
        
    }
    
    
    
    /// Function that returns an array of SwapHistory objects
    ///
    /// - Parameter result: Returns and Error and an array of SwapHistory objects. Error will be nil if  there is no error. Be sure to unwrap the swapHistory array. Iterate through swapHistories array to retrieve each individual SwapHistory object. See SwapHistory class for more information on a Swap History object. Each Swap History object has a property associated with the information it contains. For example: swapHistory._swapped is the person that was 'Swapped' and swapHistory.swap is the person that swapped. Each property also tells whether the specific social media were shared or not. It may be 'nil' or 'false' or 'true'. If swaphistory._didShareTwitter is nil or false , Twitter was not shared. It is more likely the value will be nil rather than false. If there are no records for Swap History, the array will be empty. 
    func getSwapHistory(result: @escaping (_ queryError: Error?, _ swapHistories: [SwapHistory]?) -> Void)  {
        
        // Configures so that most recent data is obtained from NoSQL
        let  config = AWSDynamoDBObjectMapperConfiguration()
        config.consistentRead = true
        
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#hashAttribute = :hashAttribute"
        queryExpression.expressionAttributeNames = ["#hashAttribute": "swap"]
        queryExpression.expressionAttributeValues = [":hashAttribute": self.username]
        
        self.NoSQL.query(SwapHistory.self, expression: queryExpression, configuration: config, completionHandler: { (output, error) in
            
            if error != nil{
                print("error querying ... \(error)")
                
                result(error, nil)
                
            }
                
            else{
                
                // Converts the response to an array of Swap History objects
                let swapHistories = output?.items as! [SwapHistory]
                result(nil, swapHistories)
                
                
            }
            
        })
        
        
    }
    
    
    /// Sets the user's One Signal User ID in database in order to send push notifications. Call this function when the user is signed in.
    func setUpPushNotifications()  {
        
        // Ensures that if a value is not passed in the function, it is ignored when saved into database
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
      
        
        OneSignal.idsAvailable { (userID, pushToken) in
            
            print("THE NOTIFICATION ID IS .... \(userID)")
            if let notificationID = userID{
                
                // Creates an 'Users' object in order to store to database
                let user = Users()
                user?._username = self.username
                user?._notification_id_one_signal = notificationID
                
                self.NoSQL.save(user!, configuration: self.updateMapperConfig, completionHandler: { (error) in
                    
                    
                })
                
            }
        }
    
        

        
        
    }
    
    
    /// Removes the user's One Signal ID from the database. Call this function when the user attempts to sign out so that it no longer receives notifications on an account that has been signed out. It sets the User ID to '0' because a one signal user ID will not be 0.
    func removePushNotificationID()  {
        
        // Ensures that if a value is not passed in the function, it is ignored when saved into database
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
        // Creates an 'Users' object in order to store to database
        let user = Users()
        user?._username = self.username
        user?._notification_id_one_signal = "0"
        
        self.NoSQL.save(user!, configuration: self.updateMapperConfig, completionHandler: { (error) in
            
            
        })
        
        
    }
    
    
    /// Sends Notification user that they have been swapped
    /// -todo: Use OneSignal API so when the user clicks the notification, he is brought to the Swap History Screen
    func sendSwappedNotification(byUser: Users)  {
        
        let nameOfUser = "\(byUser._firstname!) \(byUser._lastname!)"
        let usernameOfUser = byUser._username!
        
        
        self.getInformation { (error, user) in
            
            if error == nil{
                
                let id = user!._notification_id_one_signal!
                OneSignal.postNotification(["contents": ["en": "\(nameOfUser) (@\(usernameOfUser)) has Swapped® you."], "include_player_ids": [id]])
            }
        }
        
        
    }
    
    

    
}
