//
//  ConnectSocialMedias.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/16/16.
//
//

import Foundation
import p2_OAuth2
import Alamofire
import SwiftyJSON
import SwifteriOS
import Contacts
import Kingfisher


/// Function that follows the given user on Twitter. Authorizes the Twitter Account based on the stored Twitter Access Token and Twitter Secret Token
///
///
func shareTwitter(withUser: Users?,
                  completion: (_ error: Error?) -> Void = {noError in return})  {
    
    // Ensures a Twitter Account is Connected Before Proceeding 
    
    guard ( getTwitterConsumerKey() != nil && getTwitterSecret() != nil ) else{
        
        completion(UserError.NotConnected)
        return
    }
    
    guard let user = withUser else{
        
        // There is no user to share Pinterest with
        completion(UserError.CouldNotGetUser)
        return
    }
    
    
    let UserWillShareTwitter = user._willShareTwitter as? Bool ?? false
    
    guard UserWillShareTwitter else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let TwitterID = user._twitterID else {
        // User does not have a Twitter ID connected
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    

    let twitterAccount = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET, oauthToken: getTwitterConsumerKey()!, oauthTokenSecret: getTwitterSecret()!)
    
    
    
    
    
    twitterAccount.followUser(for: UserTag.id(TwitterID), follow: true, success: { json in
        
      
        
        // success 
        history.didShare(TwitterIs: true)
        
    }, failure: { error in
        
        
        // it failed
    })

    
}

/// Function that follows given user on Pinterest. Function will first check if a Pinterest account is configured, if not, an error will be returned in completion block. Function will also check if the user has set permission to follow on Pinterest. If there is no valid (expired) access token and refresh token, the function will attempt to authorize the user with an embedded web view controller on view controller specified.
///
/// - Parameters:
///     - withUser: Users object of user you want to follow
///     - andIfNeededAuthorizeOnViewController: usually self
///     - completion: Completion block executed. Error is nil if it succeeds in following on Pinterest.
///      - error: The error is nil if the user is successfully followed. Error = UserError.NotConnected if the current user does not have Pinterest connected. Error = UserError.CouldNotGetUser if withUser is nil. Error = UserError.WillNotShareSocialMedia if 'withUser' has Pinterest off or if 'withUser' does not have a Pinterest Account Configured.
func sharePinterest(withUser: Users?,
                    andIfNeededAuthorizeOnViewController: UIViewController,
                    completion: @escaping (_ error: Error?) -> Void  = {noError in return} ) {
    
    guard (pinterest_oauth2.accessToken != nil  || pinterest_oauth2.refreshToken != nil) else {
        
        // User does not have a Pinterest account connected
        completion(UserError.NotConnected)
        return
    }
    
    guard let user = withUser else{
        
        // There is no user to share Pinterest with 
        completion(UserError.CouldNotGetUser)
        return
    }
    
    let UserWillSharePinterest = user._willSharePinterest as? Bool ?? false
    
    guard UserWillSharePinterest else{
       
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let PinterestID = user._pinterestID else {
        // User does not have a pinterest ID connected 
 
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success 
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    
    
   
    // Sets up Authorization Screen if you need to authorize Pinterest
    pinterest_oauth2.authConfig.authorizeEmbedded = true
    
    pinterest_oauth2.authConfig.authorizeContext = andIfNeededAuthorizeOnViewController
    
    pinterest_oauth2.authConfig.ui.useSafariView = false
    
   
    // Will show login screen if cannot refresh access token with refresh token
    pinterest_oauth2.authorize { (json, error) in
        
        if let error = error {
            // There was some error trying to authorize it
            
            completion(AuthorizationError.Unknown)
            
        }
        
        else{
        
        
        var req = pinterest_oauth2.request(forURL: URL(string: "https://api.pinterest.com/v1/me/following/users/?user=\(PinterestID)")!)
        req.httpMethod = "POST"
        
        
        let task = pinterest_oauth2.session.dataTask(with: req) { data, response, error in
            
            if let error = error {
                
                // There was an error making the request 
                completion(error)
                
            }
            else {
                
                if let data = data {
                    
                    // There is data in the request
                    let jsonResponse = JSON(data: data)
                    
                    // the json response for "data" is nil if it succeeded in following
                    let followedAccount = jsonResponse["data"].string == nil
                    
                    if followedAccount{
                        // SUCCESS
                        // Set in Swap History
                        print("did follow pinterest")
                        history.didShare(PinterestIs: true)
                        completion(nil)
                    }
                    
                    else{
                        
                        completion(UserError.Unknown)
                    }
                    
                }
                
                else{
                    // No data in request 
                    completion(AuthorizationError.Unknown)
                }
                
                
        
                
    
            }
        }
        task.resume()
        
    }
    
    }

}



/// Function that follows given user on Spotify. Function will first check if a Spotify account is configured, if not, an error will be returned in completion block. Function will also check if the user has set permission to follow on Spotify. If there is no valid (expired) access token and refresh token, the function will attempt to authorize the user with an embedded web view controller on view controller specified.
/// - Author: Micheal S. Bingham
/// - Parameters:
///     - withUser: Users object of user you want to follow
///     - andIfNeededAuthorizeOnViewController: usually self
///     - completion: Completion block executed. Error is nil if it succeeds in following on Pinterest.
///      - error: The error is nil if the user is successfully followed. Error = UserError.NotConnected if the current user does not have Spotify connected. Error = UserError.CouldNotGetUser if withUser is nil. Error = UserError.WillNotShareSocialMedia if 'withUser' has Spotify off or if 'withUser' does not have a Spotify Account Configured.
func shareSpotify(withUser: Users?,
                  andIfNeededAuthorizeOnViewController: UIViewController,
                  completion: @escaping (_ error: Error?) -> Void = {noError in return})  {
    
    
    guard (spotify_oauth2.accessToken != nil || spotify_oauth2.refreshToken != nil )else {
        
        // User does not have a Spotify account connected
        completion(UserError.NotConnected)
        return
    }
    
    guard let user = withUser else{
        
        // There is no user to share Spotify with
        completion(UserError.CouldNotGetUser)
        return
    }
    
    let UserWillShareSpotify = user._willShareSpotify as? Bool ?? false
    
    guard UserWillShareSpotify else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let SpotifyID = user._spotifyID else {
        // User does not have a Spotify ID connected
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    
    
    // Sets up Authorization Screen if you need to authorize Spotify
    spotify_oauth2.authConfig.authorizeEmbedded = true
    
    spotify_oauth2.authConfig.authorizeContext = andIfNeededAuthorizeOnViewController
    
    spotify_oauth2.authConfig.ui.useSafariView = false
    
    
     // Will show login screen if cannot refresh access token with refresh token
    
    spotify_oauth2.authorize { (json, error) in
        
        
        if let error = error {
            // There was some error trying to authorize it
            
            completion(AuthorizationError.Unknown)
            
        }
            
        else{
            
            
            var req = spotify_oauth2.request(forURL: URL(string: "https://api.spotify.com/v1/me/following?type=user&ids=\(SpotifyID)")!)
            req.httpMethod = "PUT"
            
            
            let task = spotify_oauth2.session.dataTask(with: req) { data, response, error in
                
                if let error = error {
                    
                    // There was an error making the request
                    completion(error)
                    
                }
                else {
                    
                    if let data = data {
                        
                        // There is data in the request
                        let jsonResponse = JSON(data: data)
                        
                        // Parse JSON response for errors or success****
                        print("the json response for spotify follow is ....\(jsonResponse)")

                        let didFollow = jsonResponse.string == nil
                        
                        if didFollow{
                            
                            print("DID FOLLOW SPOTIFY")
                            history.didShare(SpotifyIs: true)
                            completion(nil)
                            
                        } else{
                            
                            // Did not follow user 
                            completion(UserError.Unknown)
                            
                        }
                        
                        
                    }
                        
                    else{
                        // No data in request
                        completion(AuthorizationError.Unknown)
                    }
                    
                    
                    
                    
                    
                }
            }
            task.resume()
            
        }
        
        
    }
    
    
}





/// Function that follows given user on Instagram. Function will first check if an Instagram account is configured, if not, an error will be returned in completion block. Function will also check if the user has set permission to follow on Instagram. If there is no valid (expired) access token and refresh token, the function will attempt to authorize the user with an embedded web view controller on view controller specified.
/// - Author: Micheal S. Bingham
/// - Parameters:
///     - withUser: Users object of user you want to follow
///     - andIfNeededAuthorizeOnViewController: usually self
///     - completion: Completion block executed. Error is nil if it succeeds in following on Instagram.
///      - error: The error is nil if the user is successfully followed. Error = UserError.NotConnected if the current user does not have Instagram connected. Error = UserError.CouldNotGetUser if withUser is nil. Error = UserError.WillNotShareSocialMedia if 'withUser' has Instagram off or if 'withUser' does not have a Instagram Account Configured.
func shareInstagram(withUser: Users?,
                    andIfNeededAuthorizeOnViewController: UIViewController,
                    completion: @escaping (_ error: Error?) -> Void = {noError in return})  {
    
    
    guard (instagram_oauth2.accessToken != nil || instagram_oauth2.refreshToken != nil) else {
        
        // User does not have a Instagram account connected
        completion(UserError.NotConnected)
        return
    }
 
    
    guard let user = withUser else{
        
        // There is no user to share Instagram with
        completion(UserError.CouldNotGetUser)
        return
    }
    
    let UserWillShareInstagram = user._willShareInstagram as? Bool ?? false
    
    guard UserWillShareInstagram else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let InstagramID = user._instagramID else {
        // User does not have a Instagram ID connected
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    
    
    
    // Sets up Authorization Screen if you need to authorize Instagram
    instagram_oauth2.authConfig.authorizeEmbedded = true
    
    instagram_oauth2.authConfig.authorizeContext = andIfNeededAuthorizeOnViewController
    
    instagram_oauth2.authConfig.ui.useSafariView = false
    
    
    // Will show login screen if cannot refresh access token with refresh token
    
    
    
  instagram_oauth2.authorize { (json, error) in
    
    
        
        if let error = error {
            // There was some error trying to authorize it
            print("error refreshing .. \(error)")
            completion(AuthorizationError.Unknown)
            
        }
            
        else{
            
            Alamofire.request("https://api.instagram.com/v1/users/\(InstagramID)/relationship", method: .post, parameters: ["action": "follow", "access_token": instagram_oauth2.accessToken!]).responseJSON(completionHandler: { (response) in
                
                if let data = response.data{
                    
                    let json = JSON(data: data)
                    print("instagram follow response .. \(json)")
                    
                    if let code = json["meta"]["code"].int{
                        
                        if code == 200{
                            // SUCCESS
                            // Add to Swap History 
                            history.didShare(InstagramIs: true)
                            completion(nil)
                        }
                        
                        else{
                            // No success code 
                            completion(UserError.Unknown)
                        }
                    }
                    
                    else{
                        // No success
                        
                        completion(UserError.Unknown)
                    }
                    
            
                }
                
                else{
                    // No data in reponse
                    completion(AuthorizationError.Unknown)
                }
            })
            
         
        }
        
        
   }
    
    
}

/// Function that follows the user on YouTube. See other 'share' functions for additional details to the functionality.
///
/// - Parameters:
///   - withUser: User to follow on YouTube
///   - completion: Error is nil if there is success
func shareYouTube(withUser: Users?,
                  completion: @escaping (_ error: Error?) -> Void = {noError in return})  {
    
    guard (youtube_oauth2.accessToken != nil || youtube_oauth2.refreshToken != nil) else {
        
        // User does not have a YouTube account connected
        completion(UserError.NotConnected)
        return
    }
    
    
    guard let user = withUser else{
        
        // There is no user to share YouTube with
        completion(UserError.CouldNotGetUser)
        return
    }
    
    let UserWillShareYouTube = user._willShareYouTube as? Bool ?? false
    
    guard UserWillShareYouTube else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let YouTubeID = user._youtubeID else {
        // User does not have a YouTube ID connected
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    
    
    // Continue to Subscribe on YouTube
    
    let parameters: [String: Any]? =
        [
            "snippet":
                [
                    
                    "resourceId":
                        
                        [
                            "channelId": "\(YouTubeID)"
                    ]
                    
                    
            ]
            
            
    ]
    
    
    youtube_oauth2.authorize { (json, error) in
        
        
        if error != nil{
            
            // Can't Authorize
            completion(AuthorizationError.Unknown)
        }
        
        
        else{
            
            // Subscribe on YouTube
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(youtube_oauth2.accessToken!)",
                "Accept": "application/json"
            ]
            let url = "https://www.googleapis.com/youtube/v3/subscriptions?part=snippet"
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                
                if let data = response.data{
                    let jsonReply = JSON(data: data)
                    
                    
                    
                    
                    if let id = jsonReply["id"].string{
                        
                        // Follow Attempt Worked 
                         history.didShare(YouTubeIs: true)
                        completion(nil)
                        
                    }  else{
                        
                        
                        //Did not work
                       
                        completion(UserError.CouldNotGetUser)
                    }
                    
                    
                }
                else{
                    completion(UserError.Unknown)
                }
            })
            
           
        
    }
    

}
    
}


/// Function that follows the user on SoundCloud. See other 'share' functions for additional details to the functionality.
///
/// - Parameters: 
///   - withUser: User to follow on SoundCloud
///   - andIfNeededAuthorizeOnViewController: Usually self
///   - completion: Error is nil if there is success
func shareSoundCloud(withUser: Users?,
                     andIfNeededAuthorizeOnViewController: UIViewController,
                     completion: @escaping (_ error: Error?) -> Void = {noError in return }) {
    
    
    guard (soundcloud_oauth2.accessToken != nil || soundcloud_oauth2.refreshToken != nil) else {
        
        // User does not have a SoundCloud account connected
        completion(UserError.NotConnected)
        return
    }
    
    
    guard let user = withUser else{
        
        // There is no user to share SoundCloud with
        completion(UserError.CouldNotGetUser)
        return
    }
    
    let UserWillShareSoundCloud = user._willShareSoundCloud as? Bool ?? false
    
    guard UserWillShareSoundCloud else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let SoundCloudID = user._soundcloudID else {
        // User does not have a SoundCloud ID connected
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    
    
    // Sets up Authorization Screen if you need to authorize SoundCloud
    soundcloud_oauth2.authConfig.authorizeEmbedded = true
    
    soundcloud_oauth2.authConfig.authorizeContext = andIfNeededAuthorizeOnViewController
    
    soundcloud_oauth2.authConfig.ui.useSafariView = false
    
    
    // Will show login screen if there is no valid refresh token to refresh access token 
    
    soundcloud_oauth2.authorize { (json, error) in
        
        if let _ = error {
            
            // Some error authorizing SoundCloud 
            
            completion(AuthorizationError.Unknown)
            
        }
        
        
        else{
            
            // Try to follow on SoundCloud
            
            Alamofire.request("https://api.soundcloud.com/me/followings/\(SoundCloudID).json?oauth_token=\(soundcloud_oauth2.accessToken!)&client_id=\(soundcloud_oauth2.clientId!)", method: .put).responseJSON(completionHandler: { (response) in
                
                
                if let Data = response.data{
                    
                    
                    let soundcloudJSON = JSON(data: Data)
                    // Reads JSON to check if it succeeded in following
                    print("the soundcloud response is ... \(soundcloudJSON)")
                    
                    if let status = soundcloudJSON["status"].string{
                        if status.contains("OK"){
                            
                            // SoundCloud Worked
                            
                            history.didShare(SoundCloudIs: true)
                    
                            completion(nil)
                        }
                    }
                    
                    else if let id = soundcloudJSON["id"].int{
                        
                        if "\(id)" == "\(SoundCloudID)"{
                            
                            // Soundcloud Worked
                            
                            history.didShare(SoundCloudIs: true)
                            completion(nil)
                            
                        }
                        
                        else{
                            
                            // Did not work
                            
                            completion(UserError.Unknown)
                            
                            
                        }
                        
                    }
                    
                }
                
                else{
                    
                    // No data in response 
               
                    completion(UserError.Unknown)
                }
                
                
                
            })
            
        }
        
        
        
    }
}




func shareVine(withUser: Users?,
               completion: @escaping (_ error: Error?) -> Void = {noError in return }) {
    
    
    guard getVinePassword() != nil && getVineUsername() != nil else{
        // No Vine Account Configured 
        completion(UserError.NotConnected)
        
        return
    }
    
    
    guard let user = withUser else{
        
        // There is no user to share Vine with
        completion(UserError.CouldNotGetUser)
        return
    }
    
    let UserWillShareVine = user._willShareVine as? Bool ?? false
    
    guard UserWillShareVine else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    guard let VineID = user._vineID else {
        // User does not have a Vine ID connected
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    
    // Attempt to Authorize Vine
    
    
    authorizeVine(username: getVineUsername()!, password: getVinePassword()!, completion: {
        error, key, _ in
        
        
        if error != nil{
            // Error Authorizing 
            
            completion(AuthorizationError.Unknown)
        }
        
        else{
            
            // Continue to follow Vine 
         
            let headers = ["vine-session-id": key!]
            
      
            
            
            Alamofire.request("https://api.vineapp.com/users/\(VineID)/followers", method: .post, parameters: nil, headers: headers).responseJSON(completionHandler: { (response) in
                
                
                if let data = response.data{
                   
                
                    let json = JSON(data: data)
                    print("Vine json is ... \(json)")
                    
                    print(json)
                    
                    if json["success"].boolValue{
                        
                        history.didShare(VineIs: true)
                        
                        completion(nil)
                      
                        
                    }
                    else{
                    
                        // Could not follow
                        
                         completion(UserError.Unknown)
                        
                    }
                    
                    
                    
                }
                
                else{
                    
                    
                    completion(UserError.Unknown)
                }
                
            })
            
            
        }
    })
    
}






///
/// -todo: Check if Contact already exists before adding
/// - Parameters
///   - withContactDataOfUser:
///   - completion: 
func createContactInPhone(withContactDataOfUser: Users?, completion: @escaping (_ error: Error?) -> Void)  {
    
    var DidSharePhone: Bool? = nil
    var DidShareEmail: Bool? = nil
    
    guard let user = withContactDataOfUser else{
        
        // There is no user to obtain contact
        completion(UserError.CouldNotGetUser)
        return
    }
    
    // Creates a SwapUserHistory Object in order to save in Swap History if the Follow Attempt was a success
    let history = SwapUserHistory(swap: getUsernameOfSignedInUser(), swapped: user._username!)
    
    let UserWillSharePhone = user._willSharePhone as? Bool ?? false

    let UserWillShareEmail = user._willShareEmail as? Bool ?? false
    
    guard UserWillSharePhone || UserWillShareEmail else{
        
        completion(UserError.WillNotShareSocialMedia)
        return
    }
    
    
    
    var store = CNContactStore()
    var contact = CNMutableContact()
    
    let url = URL(string: user._profilePictureUrl!)!
    
    // Set Contact Image 
    ImageDownloader.default.downloadImage(with: url , options: [], progressBlock:  nil, completionHandler: {  (image, error, url, data) in
        
        if error != nil{
            completion(error)
        }
        
        else{
            
            // Image has finished downloading
            contact.imageData = data!
            
            
            
            if let firstname = user._firstname {
                
                    contact.givenName = firstname
                
            }
            
            if let middlename = user._middlename {
               
                    contact.middleName = middlename
                
            }
            
            
            if let lastname = user._lastname {
                
                    contact.familyName = lastname
                
            }
            
            
            if let company = user._company {
              
                    contact.organizationName = company
                
            }
            
            
            
            
            if let website = user._website{
                
                    
                    //  let websiteURL = CNLabeledValue(label:CNLabelURLAddressHomePage., value: website)
                    let websiteURL = CNLabeledValue(label: "homepage", value: website as NSString)
                    
                    contact.urlAddresses = [websiteURL]
                    
                
            }
            
            
            if UserWillShareEmail{
                DidShareEmail = true
                if let email = user._email{
                   
                        
                        
                        let Email = CNLabeledValue(label: "email", value: email as NSString)
                        
                        contact.emailAddresses = [Email]
                        
                    
                }
                
            }
            
            
            if UserWillSharePhone{
                DidSharePhone = true
                
                if let phone = user._phonenumber{
                    
                        
                        
                        let Phone = CNPhoneNumber(stringValue: phone)
                        let phonenumber = CNLabeledValue(label: "iPhone", value: Phone)
                        
                        contact.phoneNumbers = [phonenumber as! CNLabeledValue<CNPhoneNumber>]
                        
                    
                }
                
            }
            
            
            
            
            // Save the date the user exchanged information
            
            let date = NSDate()
            let calendar = NSCalendar.current
            
            
            
            let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date as Date)
            
            let year =  components.year!
            let month = components.month!
            let day = components.day!
            let hour = components.hour!
            let minute = components.minute!
            
            if (minute < 10){
                
                contact.note = "Met on \(month).\(day).\(year) at \(hour):0\(minute)"
                
            }
                
            else{
                
                contact.note = "Met on \(month).\(day).\(year) at \(hour):\(minute)"
            }
            
            
            
            let request = CNSaveRequest()
            
            request.add(contact, toContainerWithIdentifier: nil)
            do{
                try store.execute(request)
              
                history.didShare( EmailIs: DidShareEmail, PhonenumberIs: DidSharePhone,completion: { (error) in
                    
                    if let error = error{
                        completion(error)
                    }
                    
                    else{
                         completion(nil)
                    }
                })
               
                
            } catch let err{
                
                // Failed trying to save contact
                
                completion(err)
            }
            
            

            
            
        }
        
        
        
    })
    


    
}
