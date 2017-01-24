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

    
    @IBOutlet weak var Twitter: UIButton!
    @IBOutlet weak var Spotify: UIButton!
    @IBOutlet weak var YouTube: UIButton!
    @IBOutlet weak var Vine: UIButton!
    @IBOutlet weak var Instagram: UIButton!
    @IBOutlet weak var Snapchat: UIButton!
    @IBOutlet weak var Pinterest: UIButton!
    @IBOutlet weak var SoundCloud: UIButton!
    @IBOutlet var dismissTutorial: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var connectSocialMediaTutorial: UIImageView!
    @IBOutlet var carrot: UIImageView!
    
    
    @IBOutlet var tapToConnect: UILabel!
    
    @IBAction func didTapConnectSocialMedia(_ sender: UIButton) {
        
        
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
                    print("it worked")
                    
                    sender.isSelected = true
                }
                
                
            })
            
            
            
            break
        case Vine:
            // Authorize Vine
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
                    
                    sender.isSelected = true
                }
                
                
            })
            
            break
        case Snapchat:
            // Authorize Snapchat
            
            authorizeReddit(onViewController: self, completion: { (error) in
                
                if let error = error{
                    
                    // There is an error
              
                    
                    
                    
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
                    
                    sender.isSelected = true
                }
                
                
            })
            
            
            break
            
        default:
            break
        }
        
        
    }
    
    @IBAction func didDismissTutorial(_ sender: Any) {
        
        tapToConnect.isHidden = true
        connectSocialMediaTutorial.isHidden = true
        dismissTutorial.isHidden = true
        nextButton.isHidden = false
        carrot.isHidden = false
        UserDefaults.standard.set(true, forKey: "ConnectSocialMediaTutorialShown")
    }
    
    
    @IBAction func didTapNext(_ sender: UIButton) {
        
         let atLeastOneSocialMediaIsConnected: Bool = (Twitter.isSelected || SoundCloud.isSelected || Pinterest.isSelected || Snapchat.isSelected || Instagram.isSelected || Vine.isSelected || YouTube.isSelected || Spotify.isSelected)
        
        
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
        Snapchat.setImage(#imageLiteral(resourceName: "SnapchatEnabled"), for: UIControlState.selected)
        Twitter.setImage(#imageLiteral(resourceName: "TwitterEnabled"), for: UIControlState.selected)
        YouTube.setImage(#imageLiteral(resourceName: "YouTubeEnabled"), for: UIControlState.selected)
        SoundCloud.setImage(#imageLiteral(resourceName: "SoundCloudEnabled"), for: UIControlState.selected)
        Pinterest.setImage(#imageLiteral(resourceName: "PinterestEnabled"), for: UIControlState.selected)
        Vine.setImage(#imageLiteral(resourceName: "VineEnabled"), for: UIControlState.selected)
        Instagram.setImage(#imageLiteral(resourceName: "InstagramEnabled"), for: UIControlState.selected)
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: self)
        
      
        
        // Selects the social media icons if they are connected
        
        Spotify.isSelected = ((spotify_oauth2.accessToken != nil) || (spotify_oauth2.refreshToken != nil))
        Instagram.isSelected = ((instagram_oauth2.accessToken != nil) || (instagram_oauth2.refreshToken != nil))
        SoundCloud.isSelected = ((soundcloud_oauth2.accessToken != nil) || (soundcloud_oauth2.refreshToken != nil))
        Pinterest.isSelected = ( (pinterest_oauth2.accessToken != nil) || (pinterest_oauth2.refreshToken != nil) )
        Twitter.isSelected = (getTwitterSecret() != nil && getTwitterToken() != nil)
        Vine.isSelected = (getVineUsername() != nil && getVinePassword() != nil )
        YouTube.isSelected = ( (youtube_oauth2.accessToken != nil) || (youtube_oauth2.refreshToken != nil) )
        
  
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          SwapUser(username: getUsernameOfSignedInUser()).setUpPushNotifications()
        
        if !UserDefaults.standard.bool(forKey: "ConnectSocialMediaTutorialShown")
        {
            carrot.isHidden = true
            nextButton.isHidden = true
        }
        else{
            connectSocialMediaTutorial.isHidden = true
            dismissTutorial.isHidden = true
            tapToConnect.isHidden = true
            
        }

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
