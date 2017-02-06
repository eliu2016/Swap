//
//  Authorizing.swift
//  Swap
//
//  Created by Micheal S. Bingham on 11/29/16.
//
//
import Foundation
import p2_OAuth2
import Alamofire
import SwiftyJSON
import Accounts
import TwitterKit

/// Clears the Tokens from User Defaults in Twitter
/// - Todo: Switch to using Keychain instead
func logoutTwitter()  {
    
    let store = Twitter.sharedInstance().sessionStore
    
    if let userID = store.session()?.userID{
        store.logOutUserID(userID)
    }
    
    UserDefaults.standard.removeObject(forKey: "TwitterToken")
    UserDefaults.standard.removeObject(forKey: "TwitterSecret")
    UserDefaults.standard.synchronize()
}



/// Clears the access tokens from keychain in each social media and clears social media login cookies.
func logoutSocialMediasAndClearCookies()  {
    
    // Clears cookies
    let storage = HTTPCookieStorage.shared
    storage.cookies?.forEach() { storage.deleteCookie($0)}
    
    logoutPinterest()
    logoutSpotify()
    logoutInstagram()
    logoutSoundCloud()
    logoutTwitter()
    logoutVine()
    logoutYouTube()
    logoutGitHub()
    logoutVimeo()
    logoutReddit()
    
    // Delete everything out of User Defaults
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    
    
}


/// Forgets the access tokens for Spotify in keychain. However, if this function is called, calling authorizeSpotify() will not show the login screen for Spotify again. The login screen will appear disapper shortly after because the login information is still stored in web cookies. Cookies have to be cleared in order to do this. See logoutSocialMediasAndClearCookies().

func logoutSpotify()  {
    
    // Forgets the access tokens in keychain
    
    
    spotify_oauth2.forgetTokens()
    
    
    
}

/// Function to authorize spotify with an embedded view controller. Function will forget access tokens first and then show the embedded view controller which instantly disappears if the user is logged in, or pops up and prompts the user to log in if the user is not logged in. Do not call this function to authorize Spotify before making a request, call spotify_oauth2.authorize() instead. Authorize() will only show the view controller if the user is logged out. Function will store the Spotify UID in the database for the user currently signed in.
///
/// - Parameters:
///   - onViewController: View Controller to show Embedded View Controller for Web on  (usually self)
///   - completion: Called when completed, error is nil if there is no error.
/// - Attention: Access tokens for Spotify DO expire; therefore, ensure that spotify_oauth2.authorize() is called whenever a request is being made. However, as of December 11, there has not being any problems reamining logged into Spotify for the purpose of making API requests.
func authorizeSpotify(onViewController: UIViewController, completion: @escaping (_ logInError: AuthorizationError?) -> Void)  {
    
    logoutSpotify()
    
    // Stuff For AlamoFire
    /*
     let sessionManager = SessionManager()
     let retrier = OAuth2RetryHandler(oauth2: spotify_oauth2)
     sessionManager.adapter = retrier
     sessionManager.retrier = retrier
     */
    
    
    
    
    // Makes the authorization in embedded view controller
    spotify_oauth2.authConfig.authorizeEmbedded = true
    
    spotify_oauth2.authConfig.authorizeContext = onViewController
    
    spotify_oauth2.authConfig.ui.useSafariView = false
    
    
    // Authorizes Spotify
    spotify_oauth2.authorize()
    
    
    spotify_oauth2.onAuthorize = { parameters in
        
        // Block is called whenever .authorize() is called and there is success
        
        // The DataLoader class ensures that a request will be made. It will authorize if needed
        var spotifyReq = spotify_oauth2.request(forURL: URL(string: SPOTIFY_USER_URL)!)
        spotifyReq.sign(with: spotify_oauth2)
        let loader = OAuth2DataLoader(oauth2: spotify_oauth2)
        loader.perform(request: spotifyReq, callback: { (response) in
            
            do{
                let spotifyJSON = try response.responseJSON()
                
                
                
                if let id = spotifyJSON["id"] as? String{
                    
                    // Sets the SpotifyID in the Database
                    
                    SwapUser(username: getUsernameOfSignedInUser()).set(SpotifyID: id, DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        
                    }, CannotSetInformation: {
                        completion(AuthorizationError.Unknown)
                    })
                    
                    
                    
                    
                }
                    
                else{
                    // ID Not Found in Spotify Response JSON
                    completion(AuthorizationError.IDNotFound)
                }
                
            }
                
            catch let _ {
                // Could not get a response for some reason.
                
                completion(AuthorizationError.Unknown)
                
                
            }
            
        })
        
        
        
    }
    
    
    spotify_oauth2.onFailure = { error in
        
        // ERROR Failed Authorizing
        
        if error == nil{
            // User cancelled authorizing
            completion(AuthorizationError.Cancelled)
            
        } else{
            // Not sure of specific Error
            completion(AuthorizationError.Unknown)
            
        }
        
    }
    
    
}

func logoutVimeo()  {
    
    vimeo_oauth2.forgetTokens()
}

func authorizeVimeo(onViewController: UIViewController,
                    completion: @escaping (_ loginError: Error?) -> ()) {
    
    logoutVimeo()
    
    vimeo_oauth2.authConfig.authorizeEmbedded = true
    
    vimeo_oauth2.authConfig.authorizeContext = onViewController
    
    vimeo_oauth2.authConfig.ui.useSafariView = false
    
    
    vimeo_oauth2.authorizeEmbedded(from: onViewController, callback:{ (json, error) in
        
        if let error = error {
            completion(error)
           
        } else{
            
            
            
            // No error 
            //Request User Data
            let vimeoLoader = OAuth2DataLoader(oauth2: vimeo_oauth2)
            let vimReq = vimeo_oauth2.request(forURL: URL(string: "https://api.vimeo.com/me")!)
            
            vimeoLoader.perform(request: vimReq, callback: { (response) in
                
              
                
                do{
                    let vimeoJSON = try response.responseJSON()
                    
                    if let idURL = vimeoJSON["uri"] as? String{
                        
                        let vimeoID = (idURL as NSString).lastPathComponent
                        
                        // Save to database 
                        
                        SwapUser(username: getUsernameOfSignedInUser()).set(VimeoID: vimeoID, DidSetInformation: {
                            
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                            
                        }, CannotSetInformation: {
                            completion(AuthorizationError.Unknown)
                        })
                    
                        
                        
                    } else {
                   
                          completion(AuthorizationError.Unknown)
                    }
                    
                    
                    
                    
                }
                    
                catch let _ {
                    // Could not get a response for some reason.
                    
                    completion(AuthorizationError.Unknown)
                    
                    
                }
                
            })
            
        }
        
    })
    
}

///Forgets the access tokens for Instagram in keychain. However, if this function is called, calling authorizeInstagram() will not show the login screen for Spotify again. The login screen will appear disapper shortly after because the login information is still stored in web cookies. Cookies have to be cleared in order to do this. See logoutSocialMediasAndClearCookies().
func logoutInstagram()  {
    
    
    instagram_oauth2.forgetTokens()
    
    
    
}


/// Function to authorize Instagram with an embedded view controller. Function will forget access tokens first and then show the embedded view controller which instantly disappears if the user is logged in, or pops up and prompts the user to log in if the user is not logged in. Do not call this function to authorize Instagram before making a request, call instagram_oauth2.authorize() instead. Authorize() will only show the view controller if the user is logged out. Function will store the Instagram UID in the database for the user currently signed in. Function also stores the Instagram profile picture URL in Userdefaults.
///
/// - Parameters:
///   - onViewController: View Controller to show Embedded View Controller for Web on  (usually self)
///   - completion: Called when completed, error is nil if there is no error.
/// - Attention: As of December 2016, Access Tokens for Instagram do not expire; however, instagram has explicitly stated that to never assume that access tokens will remain forever; therefore, always call instagram_oauth2.authorize() before making requests
func authorizeInstagram(onViewController: UIViewController, completion: @escaping (_ logInError: AuthorizationError?) -> () ) {
    
    logoutInstagram()
    
    instagram_oauth2.authConfig.authorizeEmbedded = true
    
    instagram_oauth2.authConfig.authorizeContext = onViewController
    
    instagram_oauth2.authConfig.ui.useSafariView = false
    
    instagram_oauth2.authorize()
    
    instagram_oauth2.onAuthorize = { parameters in
        
        
        let json = JSON(parameters)
        
        
        let instagramID = json["user"]["id"].string
        let imageURL = json["user"]["profile_picture"].string
        _  = json["user"]["username"].string
        
        
        saveInstagramPhoto(withLink: imageURL)
        
        SwapUser(username: getUsernameOfSignedInUser()).set(InstagramID: instagramID,
                                                            
                                                            DidSetInformation: { error  in
                                                                
                                                                // It worked.. .setting instagram ID Now
                                                                DispatchQueue.main.async {
                                                                    completion(nil)
                                                                }
                                                                
                                                                
        }, CannotSetInformation: { error in
            
            completion(AuthorizationError.Unknown)
        })
        
        
    }
    
    instagram_oauth2.onFailure = { error in
        
        // ERROR Failed Authorizing
        
        if error == nil{
            // User cancelled authorizing
            completion(AuthorizationError.Cancelled)
            
        } else{
            // Not sure of specific Error
            completion(AuthorizationError.Unknown)
            
        }
        
    }
    
    
}

/// See logoutSpotify() for more informaton. Forgets Tokens for SoundCloud
func logoutSoundCloud() {
    
    soundcloud_oauth2.forgetTokens()
    
}


/// Function to authorize SoundCloud with an embedded view controller. Function will forget access tokens first and then show the embedded view controller which instantly disappears if the user is logged in, or pops up and prompts the user to log in if the user is not logged in. Do not call this function to authorize Instagram before making a request, call soundcloud_oauth2.authorize() instead. Authorize() will only show the view controller if the user is logged out. Function will store the SoundCloud UID in the database for the user currently signed in.
///
/// - Parameters:
///   - onViewController: View Controller to show Embedded View Controller for Web on  (usually self)
///   - completion: Called when completed, error is nil if there is no error.
/// - Attention: SoundCloud access tokens do not expire; however, they do change when the user changes their pasword. Should test app for when users change passwords.

func authorizeSoundCloud(onViewController: UIViewController, completion: @escaping (_ loginError: AuthorizationError?) -> () )  {
    
    logoutSoundCloud()
    
    
    
    soundcloud_oauth2.authConfig.authorizeEmbedded = true
    
    soundcloud_oauth2.authConfig.authorizeContext = onViewController
    
    soundcloud_oauth2.authConfig.ui.useSafariView = false
    
    
    
    
    soundcloud_oauth2.authorize()
    
    
    
    
    
    
    soundcloud_oauth2.onAuthorize = {
        parameters in
        
        
        // The DataLoader class ensures that a request will be made. It will authorize if needed
        var soundcloudReq = soundcloud_oauth2.request(forURL: URL(string: "https://api.soundcloud.com/me?oauth_token=\(soundcloud_oauth2.accessToken!)")!)
        soundcloudReq.sign(with: soundcloud_oauth2)
        let loader = OAuth2DataLoader(oauth2: soundcloud_oauth2)
        
        
        loader.perform(request: soundcloudReq, callback: { (response) in
            
            do {
                
                let soundcloudJSON = try response.responseJSON()
                
                
                if let SoundCloudID = soundcloudJSON["id"] as? NSNumber{
                    
                    
                    SwapUser(username: getUsernameOfSignedInUser()).set( SoundCloudID: "\(SoundCloudID)",  DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        
                        
                        
                        
                    }, CannotSetInformation: {
                        
                        
                        completion(AuthorizationError.Unknown)
                        
                    })
                    
                    
                    
                }
                    
                else{
                    
                    completion(AuthorizationError.IDNotFound)
                }
                
                
            }
                
            catch _ {
                
                // Could not get a response
                
                completion(AuthorizationError.Unknown)
                
            }
            
            
        })
        
        
        
    }
    
    
    
    soundcloud_oauth2.onFailure = {
        error in
        
        
        // ERROR Failed Authorizing
        
        if error == nil{
            // User cancelled authorizing
            completion(AuthorizationError.Cancelled)
            
        } else{
            // Not sure of specific Error
            completion(AuthorizationError.Unknown)
            
        }
        
        
        
    }
    
}

/// See logoutSpotify() for more explanation
func logoutPinterest()  {
    
    
    pinterest_oauth2.forgetTokens()
    
}


/// Function to authorize Pinterest with an embedded view controller. Function will forget access tokens first and then show the embedded view controller which instantly disappears if the user is logged in, or pops up and prompts the user to log in if the user is not logged in. Do not call this function to authorize Instagram before making a request, call pinterest_oauth2.authorize() instead. Authorize() will only show the view controller if the user is logged out. Function will store the Pinterest UID in the database for the user currently signed in.
///
/// - Parameters:
///   - onViewController: View Controller to show Embedded View Controller for Web on  (usually self)
///   - completion: Called when completed, error is nil if there is no error.
/// - Attention: Call pinterest.authorize() before making requests because Pinterest tokens expire.
func authorizePinterest(onViewController: UIViewController, completion: @escaping (_ loginError: AuthorizationError?) -> () )  {
    
    logoutPinterest()
    
    pinterest_oauth2.authConfig.authorizeEmbedded = true
    
    pinterest_oauth2.authConfig.authorizeContext = onViewController
    
    pinterest_oauth2.authConfig.ui.useSafariView = false
    
    
    
    
    pinterest_oauth2.authorize()
    
    pinterest_oauth2.onAuthorize = {  parameters in
        
        print("the pareamters for pinterst are ... \(parameters)")
        
        Alamofire.request("https://api.pinterest.com/v1/me/?access_token=\(pinterest_oauth2.accessToken!)", method: .get).validate().responseJSON(completionHandler: { (response) in
            
            print("the response is ... \(response)")
            if let data = response.data{
                
                let json = JSON(data: data)
                print("the pinterest json is ... \(json)")
                
                if  !(json["data"]["id"].null != nil){
                    
                    let PinterestID = json["data"]["id"].stringValue
                    
                    
                    SwapUser(username: getUsernameOfSignedInUser()).set(PinterestID: PinterestID,DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            
                            completion(nil)
                        }
                        
                        
                        
                    }, CannotSetInformation: {
                        
                        completion(AuthorizationError.Unknown)
                    })
                    
                    
                    
                    
                    
                }
                else{
                    
                    completion(AuthorizationError.IDNotFound)
                }
                
                
            }
                
            else{
                
                completion(AuthorizationError.Unknown)
            }
            
            
        })
        
    }
    
    
    pinterest_oauth2.onFailure = { error in
        
        // ERROR Failed Authorizing
        
        if error == nil{
            // User cancelled authorizing
            completion(AuthorizationError.Cancelled)
            
        } else{
            // Not sure of specific Error
            completion(AuthorizationError.Unknown)
            
        }
        
    }
    
    
}


/**
 
 Function to authorize Vine account and store username and password into keychain. Method will log into Vine and return session key and userID in `completion` code block.
 
 - Author: Micheal S. Bingham
 - Copyright: (c) 2016 Micheal S. Binghan
 - Version: 2.0
 - Attention: Use this function before making HTTP Requests to vine to ensure that the user is logged into vine; however, pass the parameter false to atSetUp before making HTTP Reuqests.
 
 - Parameters:
 
 - username: The username of the Vine user.
 - password: The password of the Vine user.
 - atSetUp: Boolean value of whether the user is setting up Vine or not, set to false if making HTTP request.
 - completion: Code block with Session Key and vine Id passed in. Executed when authorization succeeds. Error is nil if succeded
 
 
 
 */



func authorizeVine(username: String?, password: String?, atSetUp: Bool = true, completion: @escaping (_ error: AuthorizationError?, _ key: String? , _ id: String? ) -> Void)  {
    
    
    guard let username = username, let password = password else{
        
        print("Not let username and password")
        completion(AuthorizationError.Cancelled, nil, nil)
        
        return
    }
    
    
    
    
    let parameters = ["username": username, "password": password]
    let vineAuthUrl = "https://api.vineapp.com/users/authenticate"
    
    Alamofire.request(vineAuthUrl, method: .post, parameters: parameters)
        .responseJSON { (response) in
            
            
            if let data = response.data {
                
                let vineResponse = JSON(data: data)
                
                print("vine response is ... \(vineResponse)")
                
                if let vineKey = vineResponse["data"]["key"].string{
                    
                    // There is Session Key for Vine so Auth did Work
                    
                    let vineID = vineResponse["data"]["userId"].stringValue
                    
                    
                    
                    if atSetUp{
                        
                        // Set Vine Auth Info in Keychain/UserDefaults
                        saveVine(username: username, andPassword: password)
                        
                        SwapUser(username: getUsernameOfSignedInUser()).set(VineID: vineID, DidSetInformation: {
                            
                            DispatchQueue.main.async {
                                
                                completion(nil, vineKey, vineID)
                            }
                            
                            
                            
                        }, CannotSetInformation: {
                            
                            completion(AuthorizationError.Unknown, nil, nil)
                        })
                        
                        
                        
                        
                        
                    }  else{
                        
                        completion(nil, vineKey, vineID)
                    }
                    
                }
                    
                else{
                    // No session key in vine response
                    completion(AuthorizationError.Cancelled, nil, nil)
                }
            }
                
            else{
                // No Data in Response
                
                
                completion(AuthorizationError.Unknown, nil, nil)
                
            }
            
            
            
    }
    
    
    
    
    
    
}

func logoutVine()  {
    
    
    UserDefaults.standard.removeObject(forKey: "VineUsername")
    UserDefaults.standard.removeObject(forKey: "VinePassword")
    UserDefaults.standard.synchronize()
}


func logoutYouTube()  {
    
    
    youtube_oauth2.forgetTokens()
    
}


func authorizeYouTube(onViewController: UIViewController, completion: @escaping (_ loginError: AuthorizationError?) -> () )  {
    
    
    logoutYouTube()
    
    
    youtube_oauth2.authorizeEmbedded(from: onViewController) { (json, error) in
        
        
        
        // The DataLoader class ensures that a request will be made. It will authorize if needed
        var youtubeReq = youtube_oauth2.request(forURL: URL(string: "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true")!)
        youtubeReq.sign(with: youtube_oauth2)
        let loader = OAuth2DataLoader(oauth2: youtube_oauth2)
        loader.perform(request: youtubeReq, callback: { (response) in
            
            do{
                
                if let data = response.data{
                    
                    let json = JSON(data: data)
                    let items = json["items"]
                    
                    
                    
                    if let channelID = items[0]["id"].string{
                        
                        var plusReq = youtube_oauth2.request(forURL: URL(string: "https://www.googleapis.com/plus/v1/people/me")!)
                        plusReq.sign(with: youtube_oauth2 )
                        let loader = OAuth2DataLoader(oauth2: youtube_oauth2)
                        
                        loader.perform(request: plusReq, callback: { (response ) in
                            
                            if let data = response.data{
                                
                                let json = JSON(data: data)
                                
                                
                                
                                let imageUrl = json["image"]["url"].stringValue
                                saveYouTubeProfilePicture(withLink: imageUrl)
                                
                                
                                // Sets the YouTube in the Database
                                
                                SwapUser(username: getUsernameOfSignedInUser()).set(YouTubeID: channelID, DidSetInformation: {
                                    
                                    DispatchQueue.main.async {
                                        completion(nil)
                                    }
                                    
                                }, CannotSetInformation: {
                                    completion(AuthorizationError.Unknown)
                                })
                                
                                
                                
                                
                                
                                
                            }
                                
                            else{
                                completion(AuthorizationError.Unknown)
                            }
                            
                        })
                        
                        
                        
                        
                    }
                        
                    else{
                        // No ID
                        completion(AuthorizationError.IDNotFound)
                    }
                    
                    
                    
                    
                    
                }
                    
                else{
                    
                    // No data in response
                    completion(AuthorizationError.Unknown)
                }
                
                
                
                
                
                
            }
                
            catch let _ {
                // Could not get a response for some reason.
                
                completion(AuthorizationError.Unknown)
                
                
            }
            
        })
        
        
        
    }
    
    youtube_oauth2.onFailure = { error in
        
        // ERROR Failed Authorizing
        
        if error == nil{
            // User cancelled authorizing
            completion(AuthorizationError.Cancelled)
            
        } else{
            // Not sure of specific Error
            completion(AuthorizationError.Unknown)
            
        }
        
    }
    
    
    
    
}


func logoutReddit()  {
    
    reddit_oauth2.forgetTokens()
}

func authorizeReddit(onViewController: UIViewController, completion: @escaping (_ loginError: Error?) -> Void)  {
    
      logoutReddit()
    
    reddit_oauth2.authConfig.authorizeEmbedded = true
    
    reddit_oauth2.authConfig.authorizeContext = onViewController
    
    reddit_oauth2.authConfig.ui.useSafariView = false
    
    
    
    
    reddit_oauth2.authorizeEmbedded(from: onViewController, params: ["duration": "permanent"] , callback:{ json, error in
        
        
        if let error = error {
            
            // Did not work
           
            completion(error)
            
        }  else{
            
            if let _ = json{
                print("if let json = json")
                // Get Reddit ID
                // Block is called whenever .authorize() is called and there is success
                
                
                
                let loader = RedditLoader()
                
                loader.requestUserdata(callback: { (json, error) in
                    
                    if let json = json {
                        
                       print("\n\n\n\n\n\n\n\n\n\n\n\n\n\nHERE IS REDDIT ... \(json)")
                        
                        if let username = json["name"] as? String {
                            
                            // Sets the YouTube in the Database
                            
                            SwapUser(username: getUsernameOfSignedInUser()).set(RedditID: username, DidSetInformation: {
                                
                                DispatchQueue.main.async {
                                    completion(nil)
                                }
                                
                            }, CannotSetInformation: {
                                completion(AuthorizationError.Unknown)
                            })
                            

                            
                        } else{
                            completion(AuthorizationError.IDNotFound)
                        }
                        
                        
                        
                    } else{
                        
                        completion(error)
                    }
                    
                    
                })
                

            }
            
        }
    })
    
    
    
    
}



func logoutGitHub()  {
    
    github_oauth2.forgetTokens()
}

func authorizeGitHub(onViewController: UIViewController, completion: @escaping (_ loginError: Error?) -> Void)  {
    
    logoutGitHub()
    
    github_oauth2.authConfig.authorizeEmbedded = true
    
    github_oauth2.authConfig.authorizeContext = onViewController
    
    github_oauth2.authConfig.ui.useSafariView = false
    
    
    github_oauth2.authorizeEmbedded(from: onViewController, callback: { (response, error) in
        
        if let error = error {
            completion(error)
        }  else{
            
            
            if let response = response{
                
             
                
                if let accessToken = github_oauth2.accessToken{
                    
                     Alamofire.request("https://api.github.com/user", method: .get, parameters: ["access_token": accessToken]).responseJSON(completionHandler: { (response) in
                        
                        if let data = response.data{
                            
                            let json = JSON(data: data)
                            
                            print("\n\n\n\n\n\n\n the github response is ... \(json)")
                            
                            if let GitHubID = json["login"].string{
                                
                                // can get an id 
                                SwapUser().set(GitHubID: GitHubID, DidSetInformation: {
                                
                                    DispatchQueue.main.async {
                                        completion(nil)
                                    }
                                    
                                })
                                
                                
                            }  else{
                                completion(AuthorizationError.IDNotFound)
                            }
                            
                        }  else{
                        
                            completion(AuthorizationError.IDNotFound)
                        }
                        
                     })
                    
                } else {
                    completion(AuthorizationError.Unknown)
                }
                
               
                
            }  else{
                
                completion(AuthorizationError.Unknown)
            }
        }
        
    })
    
}





/// Class to use Oauth with Alamofire
class OAuth2RetryHandler: RequestRetrier, RequestAdapter {
    
    let loader: OAuth2DataLoader
    
    init(oauth2: OAuth2) {
        loader = OAuth2DataLoader(oauth2: oauth2)
    }
    
    /// Intercept 401 and do an OAuth2 authorization.
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize() { authParams, error in
                self.loader.dequeueAndApply() { req in
                    if let comp = req.context as? RequestRetryCompletion {
                        comp(nil != authParams, 0.0)
                    }
                }
            }
        }
        else {
            completion(false, 0.0)   // not a 401, not our problem
        }
    }
    
    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard nil != loader.oauth2.accessToken else {
            return urlRequest
        }
        return urlRequest.signed(with: loader.oauth2)
    }
}



