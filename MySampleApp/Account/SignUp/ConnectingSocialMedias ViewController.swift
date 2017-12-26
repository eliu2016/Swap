//
//  ConnectingSocialMediasViewController.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/8/16.
//
//

import UIKit
import p2_OAuth2
import SafariServices

class ConnectingSocialMediasViewController: UIViewController, SFSafariViewControllerDelegate {

    
    @IBOutlet var Github: UIButton!
    @IBOutlet weak var Twitter: UIButton!
    @IBOutlet weak var Spotify: UIButton!
    @IBOutlet weak var YouTube: UIButton!
    @IBOutlet var Reddit: UIButton!
    @IBOutlet weak var Instagram: UIButton!
    @IBOutlet weak var Vimeo: UIButton!
    @IBOutlet weak var Pinterest: UIButton!
    @IBOutlet weak var SoundCloud: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    
    @IBAction func didTapConnectSocialMedia(_ sender: UIButton) {
        
        
        guard !sender.isSelected else{
            
            // Log out social media if it's logged in
            
            switch sender {
            case Spotify:
                logoutSpotify()
                SwapUser().set(WillShareSpotify: false)
                break
            case Pinterest:
                logoutPinterest()
                SwapUser().set(WillSharePinterest: false)
                break
            case Vimeo:
                logoutVimeo()
                SwapUser().set(WillShareVimeo: false)
                break
            case YouTube:
                logoutYouTube()
                SwapUser().set(WillShareYouTube: false)
                break
            case Instagram:
                logoutInstagram()
                SwapUser().set(WillShareInstagram: false)
                break
            case Reddit:
                logoutReddit()
                SwapUser().set(WillShareReddit: false)
                break
            case SoundCloud:
                logoutSoundCloud()
                SwapUser().set(WillShareSoundCloud: false)
                break
            case Github:
                logoutGitHub()
                SwapUser().set(WillShareGitHub: false)
                break
            case Twitter:
                logoutTwitter()
                SwapUser().set(WillShareTwitter: false)
                break
            default:
                break
            }
            
            // Disbale icon
            sender.isSelected = false
            
            return
        }
        
        
        
        // Log in
        
        switch sender {
            
        
            
        case Spotify:
            
            
            authorizeSpotify(onViewController: self, completion: { (error) in
                
                if let error = error {
                    
                    
                    // There is an error
                    
                    // Determining Error Authorizing User for This Social Media
                    switch error{
                        
                    case .Cancelled:
                        // Do nothing because the user cancelled
                        break
                    case .Unknown:
                        // Tell the user there was an error logging in
                        break
                    case .IDNotFound:
                        // Not sure of the error here, the ID was not found in the request so maybe it failed
                        break
                    }
                }
                    
                else{
                    
                    //There was no error authorizing
                    
                    // Highlights social media icon
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected = true
                }
            })
            
            break
            
        case Twitter:
            // Authorize twitter
            print("did tap authorize twitter")
            
            
            authorizeTwitter(onViewController: self, completion: { (error) in
                
                if let error = error {
                    
                    // There is an error
                    
                    // Determining Error Authorizing User for This Social Media
                    switch error{
                        
                    case .Cancelled:
                        // Do nothing because the user cancelled
                        break
                    case .Unknown:
                        // Tell the user there was an error logging in
                        break
                    case .IDNotFound:
                        // Not sure of the error here, the ID was not found in the request so maybe it failed
                        break
                    }
                }
                    
                else{
                    
                    //There was no error authorizing
                    
                    // Highlights social media icon
                    SwapUser().incrementPoints(byValue: 5) { error in
                        
                    }
                    sender.isSelected = true
                }
                
            })
            
            break
            
        case YouTube:
            // Authorize YouTube
            
            authorizeYouTube(onViewController: self, completion: { (error) in
                
                if let error = error {
                    print("there is an error ... \(error)")
                    
                    // There is an error
                    
                    // Determining Error Authorizing User for This Social Media
                    switch error{
                        
                    case .Cancelled:
                        // Do nothing because the user cancelled
                        break
                    case .Unknown:
                        // Tell the user there was an error logging in
                        break
                    case .IDNotFound:
                        // Not sure of the error here, the ID was not found in the request so maybe it failed
                        break
                    }
                }
                    
                else{
                    // It worked
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected = true
                }
                
                
            })
            
            
            
            break
        case Reddit:
            // Authorize Reddit
            
            authorizeReddit(onViewController: self, completion: { (error) in
                
                if let error = error{
                    
                    // There is an error
                    
                    
                    
                    
                } else{
                    // It worked
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected  = true
                }
            })
            

            break
            
            
        case Instagram:
            // Authorize Instagram
            
            authorizeInstagram(onViewController: self, completion: { (error) in
                
                if let error = error {
                    
                    
                    // There is an error
                    
                    // Determining Error Authorizing User for This Social Media
                    switch error{
                        
                    case .Cancelled:
                        // Do nothing because the user cancelled
                        break
                    case .Unknown:
                        // Tell the user there was an error logging in
                        break
                    case .IDNotFound:
                        // Not sure of the error here, the ID was not found in the request so maybe it failed
                        break
                    }
                }
                    
                else{
                    // It worked 
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected = true
                }
                
                
            })
            
            break
        case Vimeo:
            // Authorize Vimeo
            
            authorizeVimeo(onViewController: self, completion: { (error) in
                
                if let error = error {
                    
                    
                    // There is an error
                  
                }
                    
                else{
                    // It worked
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected = true
                }
                
                
            })
            
            
            break
        case Pinterest:
            // Authorize Pinterest
            
            
            authorizePinterest(onViewController: self, completion: { (error) in
                
                if let error = error {
                    
                    
                    // There is an error
                    
                    // Determining Error Authorizing User for This Social Media
                    switch error{
                        
                    case .Cancelled:
                        // Do nothing because the user cancelled
                        break
                    case .Unknown:
                        // Tell the user there was an error logging in
                        break
                    case .IDNotFound:
                        // Not sure of the error here, the ID was not found in the request so maybe it failed
                        break
                    }
                }
                    
                else{
                    // It worked
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected = true
                }
                
            })
            
            
            
            break
        case SoundCloud:
            // Authorize Sound Cloud
            
            
            authorizeSoundCloud(onViewController: self, completion: { (error) in
                
                if let error = error {
                    print("there is an error ... \(error)")
                    
                    // There is an error
                    
                    // Determining Error Authorizing User for This Social Media
                    switch error{
                        
                    case .Cancelled:
                        // Do nothing because the user cancelled
                        break
                    case .Unknown:
                        // Tell the user there was an error logging in
                        break
                    case .IDNotFound:
                        // Not sure of the error here, the ID was not found in the request so maybe it failed
                        break
                    }
                }
                    
                else{
                    // It worked
                    print("it worked")
                    SwapUser().incrementPoints(byValue: 5){ error in
                        
                    }
                    sender.isSelected = true
                }
                
                
            })
            
            
            break
            
        case Github:
            
            //Authorize Github
            
            authorizeGitHub(onViewController: self, completion: { (error) in
                
                if let error = error {
                    print("there is an error ... \(error)")
                    
                    // There is an error
                    
                }
                    
                else{
                    // It worked
                    print("it worked")
                    SwapUser().incrementPoints(byValue: 5){ error in 
                        
                    }
                    sender.isSelected = true
                }
                
            
            })
            
            break
            
            
            
        default:
            break
        }
        
        
    }
    
    
    @IBAction func didTapNext(_ sender: UIButton) {
        
        
         let atLeastOneSocialMediaIsConnected: Bool = (Twitter.isSelected || SoundCloud.isSelected || Pinterest.isSelected || Vimeo.isSelected || Instagram.isSelected || Reddit.isSelected || YouTube.isSelected || Spotify.isSelected || Github.isSelected)
        
        
        if atLeastOneSocialMediaIsConnected{
            // The user connected at least one social media
            // Now take them to select profile picture
            
        self.performSegue(withIdentifier: "toSelectProfilePicture", sender: self)
            
          
        }
        else{
            // Warn the user that no social medias are connected
            //Proceed
            
            self.performSegue(withIdentifier: "toSelectProfilePicture", sender: self)
            

        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Sets the default images for social media icons if they are selected
        
        Spotify.setImage(#imageLiteral(resourceName: "SpotifyEnabled"), for: UIControlState.selected)
        Vimeo.setImage(#imageLiteral(resourceName: "VimeoEnabled"), for: UIControlState.selected)
        Twitter.setImage(#imageLiteral(resourceName: "TwitterEnabled"), for: UIControlState.selected)
        YouTube.setImage(#imageLiteral(resourceName: "YouTubeEnabled"), for: UIControlState.selected)
        SoundCloud.setImage(#imageLiteral(resourceName: "SoundCloudEnabled"), for: UIControlState.selected)
        Pinterest.setImage(#imageLiteral(resourceName: "PinterestEnabled"), for: UIControlState.selected)
        Reddit.setImage(#imageLiteral(resourceName: "RedditEnabled"), for: UIControlState.selected)
        Instagram.setImage(#imageLiteral(resourceName: "InstagramEnabled"), for: UIControlState.selected)
        Github.setImage(#imageLiteral(resourceName: "GithubEnabled"), for: UIControlState.selected)
        
        
        
        
        // Selects the social media icons if they are connected
        
        Spotify.isSelected = spotifyIsConnected()
        
        Instagram.isSelected = instagramIsConnected()
        
        SoundCloud.isSelected = soundcloudIsConnected()
        
        Pinterest.isSelected = pinterestIsConnected()
        
        Twitter.isSelected = twitterIsConnected()
        
        YouTube.isSelected = youtubeIsConnected()
        
        Reddit.isSelected = redditIsConnected()
        
        Github.isSelected = githubIsConnected()
        
        Vimeo.isSelected = vimeoIsConnected()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: self)
        

  
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        
        // Selects the social media icons if they are connected
        
        Spotify.isSelected = spotifyIsConnected()
        
        Instagram.isSelected = instagramIsConnected()
        
        SoundCloud.isSelected = soundcloudIsConnected()
        
        Pinterest.isSelected = pinterestIsConnected()
        
        Twitter.isSelected = twitterIsConnected()
        
        YouTube.isSelected = youtubeIsConnected()
        
        Reddit.isSelected = redditIsConnected()
        
        Github.isSelected = githubIsConnected()
        
        Vimeo.isSelected = vimeoIsConnected()
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


func vimeoIsConnected() -> Bool {
    return ( (vimeo_oauth2.accessToken != nil) || (github_oauth2.refreshToken != nil) )
    
}

func githubIsConnected() -> Bool {
    return ( (github_oauth2.accessToken != nil) || (github_oauth2.refreshToken != nil) )
    
}

func redditIsConnected() -> Bool {
    return ( (reddit_oauth2.accessToken != nil) || (reddit_oauth2.refreshToken != nil) )
    
}


func youtubeIsConnected() -> Bool {
    return ( (youtube_oauth2.accessToken != nil) || (youtube_oauth2.refreshToken != nil) )

}

func twitterIsConnected() -> Bool {
    
    return  (getTwitterSecret() != nil && getTwitterToken() != nil)
}

func pinterestIsConnected() -> Bool {
    
    return ( (pinterest_oauth2.accessToken != nil) || (pinterest_oauth2.refreshToken != nil) )

}

func soundcloudIsConnected() -> Bool {
    
    return ((soundcloud_oauth2.accessToken != nil) || (soundcloud_oauth2.refreshToken != nil))
}

func instagramIsConnected() -> Bool {
    return ((instagram_oauth2.accessToken != nil) || (instagram_oauth2.refreshToken != nil))
}

func spotifyIsConnected() -> Bool {
    
    return ((spotify_oauth2.accessToken != nil) || (spotify_oauth2.refreshToken != nil))
}
