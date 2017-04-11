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
//import Realm
//import RealmSwift
import Swifter
import AudioToolbox

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
    
    
    
    /// Whenever a SwapUser object is created, unless otherwise specified in given username in the parameter, the object assumes it is referring to the current swap user
    init(username: String = getUsernameOfSignedInUser()) {
        
        self.username = username
       
        
        
    }
    
    /**
     Sets information of a Swap User. Will only set the information of data that is passed, if a parameter is not used, that attribute will not be altered in the database. For example, if you only want to set the first and last name, call SwapUserObject.set(Firstname: "Micheal", Lastname: "Bingham").
     
     - Attention: Do not set values using this function if you want to remove an attribute or set an empty string as a value for an attribute; this does not delete attributes nor does it save empty values for attributes.
     
     - Author: Micheal S. Bingham
     
     - Copyright: 2017 Swap Inc.
     
     - Version: 2.1
     
     - Todo: Change email in Cognito
     
     - Parameter DidSetInformation:   Completion block executed when information is set.
     - Parameter CannotSetInformation: Completion block executed when information cannot be set.
     - Parameter Firstname: The first name of the user. `String`
     - Parameter Middlename: The middle name of the user. `String`
     - Parameter Lastname: The last name of the user. `String`.
     - Parameter Phonenumber: The phone number of the user. `String`.
     - Parameter Email: The email of the user. `String`.
     - Parameter Website: The webste of the user. `String`.
     - Parameter Company: Company name of the user. `String`
     - Parameter Bio: Biographical information of user. `String`
     - Parameter Birthday: The birthday of the user as seconds since 1970. `Double`
     - Parameter Gender: M if male. F if female. `String`
     - Parameter Date_Created: The date of account creation. `Double`
     - Parameter isVerified: If the user is a `high class/verified` account. `Bool`
     - Parameter isPrivate: Set the user's account to private. `Bool`
     - Parameter Points: Sets the amount of swap points. Does not increment or decrement but sets the points to given amount. `Int`
     - Parameter Swapped: Sets the amount of `Swapped` . Does not increment or decrement but sets the points to given amount. `Int`
     - Parameter Swaps: Sets the amount of `swaps`. Does not increment or decrement but sets the points to given amount. `Int`
     - Parameter ProfileImage: Sets the profile picture with the given image URL. `String`
     - Parameter QRImage: Sets the swap code image with the given image URL. `String`
     - Parameter SpotifyID: The Spotify User ID. `String`
     - Parameter YouTubeID: The YouTube User ID. `String`
     - Parameter VineID: The Vine User ID. `String`
     - Parameter InstagramID: The Instagram User ID. `String`
     - Parameter TwitterID: The Twitter User ID for the user.  `String`
     - Parameter RedditID: The Reddit User ID for the user.  `String`
     - Parameter PinterestID: The Pinterest User ID for the user.  `String`
     - Parameter SoundCloudID: The SoundCloud User ID for the user.  `String`
     - Parameter GitHubID: The GitHub User ID for the user.  `String`
     - Parameter VimeoID: The Vimeo User ID for the user.  `String`
     - Parameter WillShareSpotify: Whether or not the usre will share Spotify. `Bool`
     - Parameter WillShareYouTube: Whether or not the usre will share YouTube. `Bool`
     - Parameter WillSharePhonenumber: Whether or not the usre will share Phone Number. `Bool`
     - Parameter WillShareVine: Whether or not the usre will share Vine. `Bool`
     - Parameter WillShareInstagram: Whether or not the usre will share Instagram. `Bool`
     - Parameter WillShareTwitter: Whether or not the usre will share Twitter. `Bool`
     - Parameter WillShareEmail: Whether or not the usre will share Email. `Bool`
     - Parameter WillShareReddit: Whether or not the usre will share Reddit. `Bool`
     - Parameter WillSharePinterest: Whether or not the usre will share Pinterest. `Bool`
     - Parameter WillShareSoundCloud: Whether or not the usre will share SoundCloud. `Bool`
     - Parameter WillShareGitHub: Whether or not the usre will share GitHub. `Bool`
     - Parameter WillShareVimeo: Whether or not the usre will share Vimeo. `Bool`
     
     
     
     */
    
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
              RedditID: String? = nil,
              PinterestID: String? = nil,
              SoundCloudID: String? = nil,
              GitHubID: String? = nil,
              VimeoID: String? = nil,
              WillShareSpotify: Bool? = nil,
              WillShareYouTube: Bool? = nil,
              WillSharePhonenumber: Bool? = nil,
              WillShareVine: Bool? = nil,
              WillShareInstagram: Bool? = nil,
              WillShareTwitter: Bool? = nil,
              WillShareEmail: Bool? = nil,
              WillShareReddit: Bool? = nil,
              WillSharePinterest: Bool? = nil,
              WillShareSoundCloud: Bool? = nil,
              WillShareGitHub: Bool? = nil,
              WillShareVimeo: Bool? = nil,
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
        user?._redditID = (RedditID != nil && !((RedditID?.isEmpty)!)) ? RedditID: nil
        user?._githubID = (GitHubID != nil && !((GitHubID?.isEmpty)!)) ? GitHubID: nil
        user?._pinterestID = (PinterestID != nil && !((PinterestID?.isEmpty)!)) ? PinterestID: nil
        user?._soundcloudID = (SoundCloudID != nil && !((SoundCloudID?.isEmpty)!)) ? SoundCloudID: nil
        user?._vimeoID = (VimeoID != nil && !((VimeoID?.isEmpty)!)) ? VimeoID: nil
        user?._willShareSpotify = (WillShareSpotify != nil) ? (WillShareSpotify! as NSNumber) : nil
        user?._willShareYouTube = (WillShareYouTube != nil) ? (WillShareYouTube! as NSNumber) : nil
        user?._willSharePhone = (WillSharePhonenumber != nil) ? (WillSharePhonenumber! as NSNumber) : nil
        user?._willShareVine = (WillShareVine != nil) ? (WillShareVine! as NSNumber) : nil
        user?._willShareInstagram = (WillShareInstagram != nil) ? (WillShareInstagram! as NSNumber) : nil
        user?._willShareTwitter = (WillShareTwitter != nil) ? (WillShareTwitter! as NSNumber) : nil
        user?._willShareEmail = (WillShareEmail != nil) ? (WillShareEmail! as NSNumber) : nil
        user?._willShareReddit = (WillShareReddit != nil) ? (WillShareReddit! as NSNumber) : nil
        user?._willSharePinterest = (WillSharePinterest != nil) ? (WillSharePinterest! as NSNumber) : nil
        user?._willShareSoundCloud = (WillShareSoundCloud != nil) ? (WillShareSoundCloud! as NSNumber) : nil
         user?._willShareGitHub = (WillShareGitHub != nil) ? (WillShareGitHub! as NSNumber) : nil
        user?._willShareVimeo = (WillShareVimeo != nil) ? (WillShareVimeo! as NSNumber) : nil
        
        if let linkToProfileImage = ProfileImage{
            // User setted Profile Picture so we have to set it in amazon cognito
            
            
            
            let ProfilePictureURL = AWSCognitoIdentityUserAttributeType()
            ProfilePictureURL?.name = "picture"
            ProfilePictureURL?.value = linkToProfileImage
            
            
            
            
            pool.getUser(self.username).update([ProfilePictureURL!])
        }
        
        if isVerified ?? false{
            
            // Set verified in database
            
            let verified = AWSCognitoIdentityUserAttributeType()
            verified?.name = "profile"
            verified?.value = "IS_VERIFIED"
            
            
            
            
            pool.getUser(self.username).update([verified!])
        }
        
        if let email = Email{
            
            // Sets Email in Amazon Cognito 
        
            
            let email_attribute = AWSCognitoIdentityUserAttributeType()
            email_attribute?.name = "email"
            email_attribute?.value = email
            
            pool.getUser(self.username).update([email_attribute!])
        
        }
        
        if let number = Phonenumber{
            
            // Sets Phonen umber in Amazon Cognito
            
            
            let n = AWSCognitoIdentityUserAttributeType()
            n?.name = "phone_number"
            n?.value = number
            
            pool.getUser(self.username).update([n!])
            
        }
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        
        self.NoSQL.save(user!, configuration: self.updateMapperConfig, completionHandler: { error in
            
            DispatchQueue.main.async {
                
            
            if error != nil{
                
                print("Can set information")
                CannotSetInformation()
            }
                
            else{
                
                
                
                DidSetInformation()
                
            }
                
        }
            
            
        })
        
     }
    
    }
    
    func updateProfileInfoWith(Middlename: String? = nil, Company: String? = nil, Website: String? = nil,  DidSetInformation: @escaping () -> Void? = { return nil },  CannotSetInformation: @escaping () -> Void? =  { return })  {
        
        // Ensures that if a value is not passed in the function, it is deleted when saved into database
        updateMapperConfig.saveBehavior = .update
        
        
        
        self.getInformation { (error, user) in
            
            user?._middlename = (Middlename != nil && !((Middlename?.isEmpty)!)) ? Middlename?.trim(): nil
            user?._website = (Website != nil && !((Website?.isEmpty)!)) ? Website?.trim(): nil
            user?._company = (Company != nil && !((Company?.isEmpty)!)) ? Company?.trim(): nil
            
            DispatchQueue.global(qos: .userInteractive).async {
                
            
            self.NoSQL.save(user!, configuration: self.updateMapperConfig, completionHandler: { error in
                
                DispatchQueue.main.async {
                    
                
                if error != nil{
                    
                    print("Can set information")
                    CannotSetInformation()
                }
                    
                else{
                    
                    
                    
                    DidSetInformation()
                    
                }
                
            }
                
                
            })
            
    }
        
        }
        
        
    }
    
    
    func getInformation(completion: @escaping (_ error: UserError?,  _ userData: Users? ) -> Void) {
        
        
        
        
        
        // Configures so that most recent data is obtained from NoSQL
        let  config = AWSDynamoDBObjectMapperConfiguration()
        config.consistentRead = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.NoSQL.load(Users.self, hashKey: self.username, rangeKey: nil, configuration: config, completionHandler: { (user, error) in
                
                if error != nil {
                    print("there was an error loading data..\nThe error is \(error.debugDescription)")
                    let usererror: UserError = UserError.CouldNotGetUser
                    completion(usererror, nil)
                }
                    
                else{
                    // There is no error
                    
                    DispatchQueue.main.async {
                        
                        if user != nil{
                            
                            let user = user as! Users
                            completion(nil, user)
                            
                        } else{
                            
                            let usererror: UserError = UserError.CouldNotGetUser
                            completion(usererror, nil)
                        }
                        
                    }
                    
                    
                    
                }
                
            })
            
        }
       
        
        
        
        
        
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
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.NoSQL.query(SwapHistory.self, expression: queryExpression, configuration: nil, completionHandler: { (output, error) in
                
                DispatchQueue.main.async {
                    
                    if error != nil{
                        print("error querying ... \(error)")
                        
                        result(error, nil)
                        
                    }
                        
                    else{
                        
                        // Converts the response to an array of Swap History objects
                        let swapHistories = output?.items as! [SwapHistory]
                        result(nil, swapHistories)
                        
                        
                        
                        
                    }
                }
                
               
            })
        }
       
        
        
    }
    
    
    /// Uploads a Profile Picture given the UIImage Data
    ///
    /// - Parameters:
    ///   - withData: Data representation of the image
    ///   - completion: If the error is nil, it has suceeded and the profile picture has been updated in Database
    func uploadProfilePicture(withData: Data, completion: @escaping (_ error: Error?) -> Void)  {
        
        let randomNumber = Date().timeIntervalSince1970 as Double
        
        
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
    func incrementSwaps(byValue: NSNumber = 1, completion: @escaping (_ error: Error?) -> Void)  {
        
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
            
            DispatchQueue.main.async {
                completion(error)
            }
        })
        
        
        
    }
    
    func incrementSwapped(byValue: NSNumber = 1, completion: @escaping (_ error: Error?) -> Void)  {
        
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
            
            DispatchQueue.main.async {
                completion(error)
            }
        })
        
        
    }
    
    func incrementPoints(byValue: NSNumber = 1, completion: @escaping (_ error: Error?) -> Void)  {
        
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
            
            DispatchQueue.main.async {
                completion(error)
            }
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
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.NoSQL.query(SwapHistory.self, expression: queryExpression, configuration: config, completionHandler: { (output, error) in
                
                DispatchQueue.main.async {
                    
                    if error != nil{
                        print("error querying ... \(error)")
                        
                        result(error, nil)
                        
                    }
                        
                    else{
                        
                        // Converts the response to an array of Swap History objects
                        let swapHistories = output?.items as! [SwapHistory]
                        result(nil, swapHistories)
                        
                        
                    }
                }
               
                
            })
        }
       
        
        
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
    func sendSwappedNotification(bySwapUser: SwapUser)  {
        
        
        
        
        bySwapUser.getInformation { (error, byUser) in
            
            if let byUser = byUser {
                
                
                let nameOfUser = "\(byUser._firstname!) \(byUser._lastname!)"
                let usernameOfUser = byUser._username!
                
                
                self.getInformation { (error, user) in
                    
                    if error == nil{
                        
                        if let id = user!._notification_id_one_signal{
                            
                            OneSignal.postNotification(["contents": ["en": "\(nameOfUser) (@\(usernameOfUser)) has Swapped™ you."],
                                  "content_available": true,
                                  "ios_badgeType": "Increase",
                                  "ios_badgeCount": "1",
                                  "include_player_ids": [id]])
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
        
        
    }
    
    
    func sendSwapRequest(toSwapUser: SwapUser, completion: @escaping (_ error: Error?) -> Void = {_ in return})  {
        
        let request = SwapRequest()
        
        request?._sender = self.username
        request?._requested = toSwapUser.username
        request?._sent_at = NSDate().timeIntervalSince1970 as NSNumber // Current Time
        request?._status = false // Not accepted yet
        request?._sender_confirmed_acceptance = false // Sender has not confirmed yet
        request?._requested_user_has_responded_to_request = false
        
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
        NoSQL.save(request!, configuration
            : updateMapperConfig, completionHandler: { error in
                
                if error == nil{
                    
                    
                    self.getInformation(completion: { (error, me) in
                        
                        if let sender = me{
                            
                            // Send Swap Request Notification To User
                            toSwapUser.getInformation(completion: { (error, user) in
                                
                                if let user = user {
                                    // Did get information and there is no error
                                    
                                    let nameOfUser = "\(sender._firstname!) \(sender._lastname!)"
                                    let usernameOfUser = sender._username!
                                    
                                    if let id = user._notification_id_one_signal{
                                        // Can send a notification to user
                                        
                                        // Sends notification to user
                                        OneSignal.postNotification([
                                            "contents": ["en": "\(nameOfUser) (@\(usernameOfUser)) requested to Swap™ you."],
                                            "include_player_ids": [id],
                                            "content_available": true,
                                            "ios_badgeType": "Increase",
                                            "ios_badgeCount": "1",
                                            "buttons": [
                                                ["id": "Accept", "text": "Accept"],
                                                ["id": "Decline", "text": "Decline"] ],
                                            "data": ["username": usernameOfUser]
                                            ])
                                    }
                                }
                                
                            })
                        }
                        
                    })
                    
                    
                    
                }
                
                
                // Error will be nil if everything worked
                completion(error)
                
        })
        
        
    }
    
    
    func sendNotifcationOfSwapRequestAcceptanceToUser(withUsername: String)  {
        
        self.getInformation { (error, thisUser) in
            
            if let thisUser = thisUser{
                let nameOfUser = "\(thisUser._firstname!) \(thisUser._lastname!)"
                let username = thisUser._username!
                
                
                SwapUser(username: withUsername).getInformation { (error, user) in
                    
                    if let user = user {
                        if let id = user._notification_id_one_signal{
                            
                
                            // Send Notification to User withUsername that the Swap Request has been accepted
                            
                            // Sends notification to user
                            OneSignal.postNotification([
                                "contents": ["en": "\(nameOfUser) (@\(username)) has accepted your Swap™ Request."],
                                  "content_available": true,
                                  "ios_badgeType": "Increase",
                                  "ios_badgeCount": "1",
                                "include_player_ids": [id]
                                ])
                            
                        }
                    }
                }
                
                
            }
            
            
        }
        
        
       
        
    }
    
    
    /// Function that returns an array of SwapRequest objects
    ///
    /// - Parameter result: Returns an array of SwapRequests that the user has sent out. When obtaining the swap requests array, ensure that the status (swapRequest.status) == true before allowing the user to press the swap button to confirm. The status property tells if the requested user has accepted  a swap request. If the user has ignored the swap request, status will be false. If the user has denied a swap request, it will not be shown in the array. Here is an example: If David a private user and Micheal sends a swap request to David.  Initially, the sender is Micheal, the requested is David, the status is false, and sender_confirmed_acceptance is also false. If David accepts the friend request, status = true when Micheal attempts to getPendingSentSwapRequests. If David has neither accepted or denied request, status = true. However, if David denies the request, the request is removed from getPendingSentSwapRequest and status = false AND sender_confirmed = true.
    func getPendingSentSwapRequests(result: @escaping (_ error: Error?, _ requests: [SwapRequest]?) -> Void)  {
        
        // Configures so that most recent data is obtained from NoSQL
        
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "sender"
        queryExpression.keyConditionExpression = "#hashAttribute = :hashAttribute"
        queryExpression.expressionAttributeNames = ["#hashAttribute": "sender", "#sender_confirmed_acceptance":"sender_confirmed_acceptance"]
        queryExpression.expressionAttributeValues = [":hashAttribute": self.username, ":val": false]
        queryExpression.filterExpression = "#sender_confirmed_acceptance = :val"
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.NoSQL.query(SwapRequest.self, expression: queryExpression,  completionHandler: { (output, error) in
                
                DispatchQueue.main.async {
                    
                    if error != nil{
                        
                        
                        result(error, nil)
                        
                    }
                        
                    else{
                        
                        // Converts the response to an array of Swap History objects
                        let swapRequests = output?.items as! [SwapRequest]
                        result(nil, swapRequests)
                        
                        
                    }
                }
               
                
            })
        }
        
        
        
    }
    
    
    /// If Micheal sends David a Swap Request and David accepts it, this function should be called where withUsername = David so that sender_confirmed = true so that it is removed from the getPendingSentSwapRequests array.
    ///
    ///
    func confirmSwapRequestToUser(withUsername: String, completion: @escaping (_ error: Error?) -> Void = {_ in return })  {
        
        let swapRequest = SwapRequest()
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
        swapRequest?._sender = self.username
        swapRequest?._requested = withUsername
        
        
        
        swapRequest?._sender_confirmed_acceptance = true
        
        NoSQL.save(swapRequest!, configuration: updateMapperConfig, completionHandler: { error in
            
            completion(error)
            
        })
        
    }
    
    
    func performActionOnSwapRequestFromUser(withUsername: String, doAccept: Bool, completion: @escaping (_ error: Error?) -> Void = {_ in return })  {
        
        let swapRequest = SwapRequest()
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        
        swapRequest?._sender = withUsername
        swapRequest?._requested = self.username
        
        swapRequest?._status = doAccept as NSNumber
        
        swapRequest?._requested_user_has_responded_to_request = true as NSNumber
        
        if !doAccept{
            // Sender rejected the Swap Request. So now, set senderConfirmed = true so that it no longer appears on their pending Swap Requests
            
            swapRequest?._sender_confirmed_acceptance = true
        }
        
        
        NoSQL.save(swapRequest!, configuration: updateMapperConfig, completionHandler: { error in
            
            if error == nil {
               
                if doAccept {
                    self.sendNotifcationOfSwapRequestAcceptanceToUser(withUsername: withUsername)
                }
                
            }
            completion(error)
            
        })
        
    }
    
    /// Gets the Swap Requests sent to the user
    func getRequestedSwaps(result: @escaping (_ error: Error?, _ requests: [SwapRequest]?) -> Void)  {
        
        
        // Configures so that most recent data is obtained from NoSQL
        
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "requested"
        queryExpression.keyConditionExpression = "#hashAttribute = :hashAttribute"
        
        // Attribute Names for Query
        queryExpression.expressionAttributeNames = ["#hashAttribute": "requested", "#requested_user_has_responded_to_request":"requested_user_has_responded_to_request"]
        
        // Values for Query 
        
        queryExpression.expressionAttributeValues = [":hashAttribute": self.username, ":val": false]
        queryExpression.filterExpression = "#requested_user_has_responded_to_request = :val"
        
        
        self.NoSQL.query(SwapRequest.self, expression: queryExpression,  completionHandler: { (output, error) in
            
            if error != nil{
                
                
                result(error, nil)
                
            }
                
            else{
                
                // Converts the response to an array of Swap History objects
                let swapRequests = output?.items as! [SwapRequest]
                result(nil, swapRequests)
                
                
            }
            
        })
    }
    
    /// Use this function to check if user has swapped another user. 
    func hasSwapped(withUser: SwapUser, result: @escaping (_ hasSwapped: Bool) -> Void)  {
        
        // hashKey/swap = self
        // rangeKey/swapped = withUser
        
        self.NoSQL.load(SwapHistory.self, hashKey: self.username, rangeKey: withUser.username, completionHandler: { (request, error) in
            
            if let error = error{
                
                
                
                
                
                result(false)
                
                
                
            } else{
                
                if let _ = request as? SwapHistory{
                
                    result(true)
                }
                else{
                    
                    result(false)
                }
                
                
                
            }
            
            
            
            
        })
        
    }
    
    /*
    /// Downloads the social media compilation of the user
    func downloadCompilation()  {
        
        
        let username = self.username
        
        
        // Get Compilation Object Or Create One if It doesn't exist
        
        let compilation = Compilation()
        compilation.id = username
        
        self.getInformation { (error, user) in
            
            if let user = user {
                
                
                // Update Compilation Object
                let realm1 = try! Realm()
                try! realm1.write {
                    
                    realm1.create(Compilation.self, value: ["id": username, "name": "\(user._firstname!) \(user._lastname!)",  "isVerified": user._isVerified?.boolValue ?? false, "profilePicture": user._profilePictureUrl!], update: true)
                    
                }
                
                
                // Download Tweets
                if let token = getTwitterToken(), let secret = getTwitterSecret(){
                    
                    let swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET, oauthToken: token, oauthTokenSecret: secret)
                    
                    if let twitterID = user._twitterID{
                        
                        swifter.getTimeline(for: twitterID, success: { (twitterJSON) in
                            
                            
                            let realm2 = try! Realm()
                            realm2.refresh()
                            
                            if  let ownerCompilation =  realm2.object(ofType: Compilation.self, forPrimaryKey: username){
                                // Can get compilation object from database
                                
                                
                                var dateUpdated = ownerCompilation.updatedAt
                                var hasSeen = ownerCompilation.hasBeenViewed
                                
                                if let tweets = returnTweets(fromJSON: twitterJSON){
                                    
                                    
                                    
                                    if tweets.count != ownerCompilation.Tweets.count{
                                        
                                        // New Tweets have been added since before
                                        
                                        // Update the dateUpdated
                                        
                                        dateUpdated = Date()
                                        
                                        hasSeen = false
                                        
                                        
                                    }
                                    
                                    try! realm2.write {
                                        
                                        realm2.create(Compilation.self, value: ["id": username, "Tweets": tweets, "updatedAt": dateUpdated as Date?, "hasBeenViewed": hasSeen], update: true)
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                        })
                    }
                    
                    
                }
                
            }
        }
        
        
        
    } */
    
    func swap(with userWithUsername: String, authorizeOnViewController: UIViewController, overridePrivateAccount: Bool = false, method: SwapMethod = .scan, completion: @escaping (_ error: Error?, _ user: Users?) -> Void){
       
        guard self.username != userWithUsername else{
            
            completion(UserError.CannotFollowSelf, nil)
            return 
        }
        
        SwapUser(username: userWithUsername).getInformation(completion: { (error, user) in
            
        
            if error != nil {
                
                // There was an error trying to get the user from the swap code
                
                print("Could not get user.. Not a valid Swap Code... User does not exist...or bad internet connection")
                DispatchQueue.main.async {
                     completion(error, nil)
                }
               
        
            }
            
            
            if let user = user{
                
                // Could get user
                
                let userIsPrivate = user._isPrivate as! Bool
                
                let shouldSendSwapRequest = overridePrivateAccount ? false : userIsPrivate
                
                if shouldSendSwapRequest{
                    
                    SwapUser(username: getUsernameOfSignedInUser()).sendSwapRequest(toSwapUser:  SwapUser(username: user._username!), completion: { error in
                        
                        if error != nil {
                            
                            completion(error, nil)
                         
                        } else {
                            
    
                            // Request Sent
                            
                            
                            // Log analytics
                            Analytics.didSwap(byMethod: method, isPrivate: true)
                            
                             DispatchQueue.main.async {
                                
                               AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                                completion(nil, user)
                            }
                            
                            
                        }
                        
                        
                    })
                    
                }
                    
                else{
                    //configure confirm swap screen
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                    
                   
                    
                    let currentUser = self
                    let otherUser =   SwapUser(username: user._username!)
                    
                    // Check if already Swapped
                    currentUser.hasSwapped(withUser: otherUser, result: { (hasSwapped) in
                        
                        
                        if !hasSwapped{
                            
                            // Didn't Swap Yet
                            
                            currentUser.incrementSwaps { error in
                                
                            }
                            otherUser.incrementSwapped{ error in
                                
                            }
                            currentUser.incrementPoints(byValue: 5) { error in
                                
                            }
                            otherUser.incrementPoints(byValue: 5){ error in
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                    })
                        let history = SwapUserHistory(swap: self.username, swapped: userWithUsername)
                        history.didShare()
                        
                        // Share social medias
                        shareVine(withUser: user)
                        shareSpotify(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        createContactInPhone(withContactDataOfUser: user, completion: {_ in return })
                        shareInstagram(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        shareTwitter(withUser: user)
                        shareYouTube(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        shareSoundCloud(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        sharePinterest(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        shareReddit(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        shareGitHub(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                        shareVimeo(withUser: user, andIfNeededAuthorizeOnViewController: authorizeOnViewController)
                   
                    otherUser.sendSwappedNotification(bySwapUser: SwapUser(username: getUsernameOfSignedInUser()))
                    
                    // Log Analytics // If current user has social media connected and the other has the social media 'on' then essentially the user has shared that social media. +- ~3% margin error perhaps
                    
                    // ========= Begin Loggin Analytics ====================================
                    let sharedSpotify = (spotify_oauth2.accessToken != nil || spotify_oauth2.refreshToken != nil) && (user._willShareSpotify?.boolValue ?? false) && (user._spotifyID != nil)
                    
                    let sharedPhone =  (user._willSharePhone?.boolValue ?? false)
                    let sharedEmail =  (user._willShareEmail?.boolValue ?? false)
                    
                    let sharedInstagram = (instagram_oauth2.accessToken != nil || instagram_oauth2.refreshToken != nil) && (user._willShareInstagram?.boolValue ?? false) && user._instagramID != nil
                    
                    let sharedReddit = (reddit_oauth2.accessToken != nil || spotify_oauth2.refreshToken != nil) && (user._willShareSpotify?.boolValue ?? false) && user._redditID != nil
                    
                    let sharedTwitter = (getTwitterToken() != nil && getTwitterSecret() != nil ) && (user._willShareTwitter?.boolValue ?? false) && user._twitterID != nil
                    
                    
                    let sharedYouTube = (youtube_oauth2.accessToken != nil || youtube_oauth2.refreshToken != nil) && (user._willShareYouTube?.boolValue ?? false) && user._youtubeID != nil
                    
                    let sharedSoundCloud = (soundcloud_oauth2.accessToken != nil || soundcloud_oauth2.refreshToken != nil) && (user._willShareSoundCloud?.boolValue ?? false) && user._soundcloudID != nil
                    
                    let sharedPinterest = (pinterest_oauth2.accessToken != nil || pinterest_oauth2.refreshToken != nil) && (user._willSharePinterest?.boolValue ?? false) && user._pinterestID != nil
                    
                    let sharedGitHub = (github_oauth2.accessToken != nil || github_oauth2.refreshToken != nil) && (user._willShareGitHub?.boolValue ?? false) && user._githubID != nil
                    
                    let sharedVimeo = (vimeo_oauth2.accessToken != nil || vimeo_oauth2.refreshToken != nil) && (user._willShareVimeo?.boolValue ?? false) && user._vimeoID != nil
                    
                    Analytics.didSwap(byMethod: method, didShareSpotify: sharedSpotify, didSharePhone: sharedPhone, didShareEmail: sharedEmail, didShareInstagram: sharedInstagram, didShareReddit: sharedReddit, didShareTwitter: sharedTwitter, didShareYouTube: sharedYouTube, didShareSoundCloud: sharedSoundCloud, didSharePinterest: sharedPinterest, didShareGitHub: sharedGitHub, didShareVimeo: sharedVimeo)
                    
                    // ========= End Logging Analytics ====================================
                    
                    DispatchQueue.main.async {
                        
                        
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            completion(nil, user)
                    }
                
                    }
                }
                
            }
            
            
        })
        
    }
    
    
}

