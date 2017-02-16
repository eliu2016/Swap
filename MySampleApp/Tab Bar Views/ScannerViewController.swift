//
//  ScannerView.swift
//  Swap
//
//  Created by David Slakter on 1/7/17.
//
//

import Foundation
import SwiftQRCode
import AVFoundation
import Spring


let scanner = QRCode(autoRemoveSubLayers: false, lineWidth: CGFloat(nan: 0,signaling: true) , strokeColor: UIColor.clear, maxDetectedCount: 1)

class ScannerViewController: UIViewController {

    @IBOutlet var confirmSwapLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var confirmSwapButton: UIButton!
    @IBOutlet var enableCameraLabel: UILabel!
    @IBOutlet var enableCameraButton: UIButton!
    
    var confirmSwapBackground: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circularImage(photoImageView: profilePic)
        profilePic.isHidden = true
        confirmSwapLabel.isHidden = true
        confirmSwapButton.isHidden = true
        
        enableCameraLabel.isHidden = true
        enableCameraButton.isHidden = true
        
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType:
            AVMediaTypeVideo)
        
        switch authStatus {
        case .authorized: break
        case .denied:
            
            enableCameraLabel.isHidden = false
            enableCameraButton.isHidden = false
            
            break
            
        default: break
        }
        
        
        scanner.prepareScan(self.view){ (swapLink) in
            
            
            let username = getUsernameFromSwapLink(swapLink: swapLink)
            
            
            
            SwapUser(username: username).getInformation(completion: { (error, user) in
                
                // Stop Scanner
                scanner.stopScan()
                
                
                if error != nil {
                    
                    // There was an error trying to get the user from the swap code
                    
                    print("Could not get user.. Not a valid Swap Code... User does not exist...or bad internet connection")
                    
                    
                    // Restart Scanner After Showing Pop Up View
                    scanner.startScan()
                    
                    
                }
                
                
                if let user = user{
                    
                    // Could get user
                    
                    let userIsPrivate = user._isPrivate as! Bool
                    
                    if userIsPrivate{
                        
                        SwapUser(username: getUsernameOfSignedInUser()).sendSwapRequest(toSwapUser:  SwapUser(username: user._username!), completion: { error in
                            
                            if error != nil {
                                
                                // Some error happened
                             
                                scanner.startScan()
                                
                            }  else{
                                
                                //confirm swap
                                DispatchQueue.main.async {
                                    
                                    self.confirmSwapBackground = self.newConfirmView()
                                    self.view.addSubview(self.confirmSwapBackground!)
                                    self.view.bringSubview(toFront: self.profilePic)
                                    self.view.bringSubview(toFront: self.confirmSwapLabel)
                                    self.view.bringSubview(toFront: self.confirmSwapButton)
                                
                                    self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl!))
                                
                                    self.confirmSwapLabel.text = "Request sent to " + user._firstname! + " " + user._lastname!
                                
                                    self.profilePic.isHidden = false
                                    self.confirmSwapLabel.isHidden = false
                                    self.confirmSwapButton.isHidden = false
                                }
                                // Request Sent
                                

                                
                                // Log analytics
                               Analytics.didSwap(byMethod: .swapcode, isPrivate: true)
                              
                                
                            }
                            
                            
                        })
                        
                    }
                        
                    else{
                        //configure confirm swap screen
                        DispatchQueue.main.async {
                            
                            self.confirmSwapBackground = self.newConfirmView()
                            self.view.addSubview(self.confirmSwapBackground!)
                            
                            self.view.bringSubview(toFront: self.profilePic)
                            self.view.bringSubview(toFront: self.confirmSwapLabel)
                            self.view.bringSubview(toFront: self.confirmSwapButton)
                        
                            self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl!))
                        
                            self.confirmSwapLabel.text =  user._firstname! + " " + user._lastname!
                            
                            self.profilePic.isHidden = false
                            self.confirmSwapLabel.isHidden = false
                            self.confirmSwapButton.isHidden = false
                        }
                        
                        // Share social medias
                        shareVine(withUser: user)
                        shareSpotify(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        createContactInPhone(withContactDataOfUser: user, completion: {_ in return })
                        shareInstagram(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        shareTwitter(withUser: user)
                        shareYouTube(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        shareSoundCloud(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        sharePinterest(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        shareReddit(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        shareGitHub(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        shareVimeo(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        
                        
                        SwapUser(username: user._username!).sendSwappedNotification(bySwapUser: SwapUser(username: getUsernameOfSignedInUser()))
                
                        
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
                        
                        Analytics.didSwap(byMethod: .swapcode, didShareSpotify: sharedSpotify, didSharePhone: sharedPhone, didShareEmail: sharedEmail, didShareInstagram: sharedInstagram, didShareReddit: sharedReddit, didShareTwitter: sharedTwitter, didShareYouTube: sharedYouTube, didShareSoundCloud: sharedSoundCloud, didSharePinterest: sharedPinterest, didShareGitHub: sharedGitHub, didShareVimeo: sharedVimeo)
                        
                        // ========= End Logging Analytics ====================================
                        
                        
                    }
                    
                }
                
                
            })
            
            
        }
        
        scanner.scanFrame = view.bounds
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanner.startScan()
       
    }
    
    @IBAction func enableCamera(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        
    }
    @IBAction func didPressDone(_ sender: Any) {
        
        profilePic.isHidden = true
        confirmSwapLabel.isHidden = true
        confirmSwapButton.isHidden = true
        fall(imageView: confirmSwapBackground!)
        
        //restart the scanner
        scanner.startScan()
    }
    func newConfirmView() -> UIImageView {
        
        let image = #imageLiteral(resourceName: "ConfirmSwapBackground")
        let imageView = SpringImageView(image: image)
        
        let storyboardName = self.storyboard?.value(forKey: "name")
       
    
        let storyboardString = storyboardName as! String
        
        switch storyboardString {
        case "Main":
            imageView.frame = CGRect(x: 99, y: 180, width: 176, height: 151)
            break
            
        case "4.7in":
            imageView.frame = CGRect(x: 70, y: 270, width: 237, height: 126)
            break
            
        case "4in":
            imageView.frame = CGRect(x: 52, y: 241, width: 219, height: 103)
            break
            
        case "3.5in":
            imageView.frame = CGRect(x: 51, y: 195, width: 219, height: 103)
            break
            
        default:
            break
        }
        
        
        return imageView
    }

    
}


func getUsernameFromSwapLink(swapLink: String) -> String {
    
    return (swapLink as NSString).lastPathComponent.lowercased()
    
    
}

func fall(imageView: UIImageView){
    let layer = imageView as! SpringImageView
    layer.animation = "fall"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}


 func fall(button: UIButton)  {
    let layer = button as! SpringButton
    layer.animation = "fall"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}

func fall(label: UILabel){
    let layer = label as! SpringLabel
    layer.animation = "fall"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}
