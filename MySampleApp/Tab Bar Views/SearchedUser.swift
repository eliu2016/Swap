//
//  SearchedUser.swift
//  Swap
//
//  Created by David Slakter on 1/27/17.
//
//

import Foundation
import Kingfisher


var searchedUser = ""

class SearchedUser: UIViewController {
    
    @IBOutlet var BlurView1: UIVisualEffectView!
    @IBOutlet var BlurView2: UIVisualEffectView!
    @IBOutlet var BlurView3: UIVisualEffectView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var verifiedIcon: UIImageView!
    
    @IBOutlet var swapButton: UIButton!
    
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var pointsNumberLabel: UILabel!
    @IBOutlet var swappedNumberLabel: UILabel!
    @IBOutlet var swapsNumberLabel: UILabel!
    
    @IBOutlet var Spotify: UIImageView!
    @IBOutlet var Contact: UIImageView!
    @IBOutlet var Instagram: UIImageView!
    @IBOutlet var Pinterest: UIImageView!
    @IBOutlet var SoundCloud: UIImageView!
    @IBOutlet var YouTube: UIImageView!
    @IBOutlet var Twitter: UIImageView!
    
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    override func viewDidLoad() {
    
        self.tabBarController?.tabBar.backgroundImage = #imageLiteral(resourceName: "Subheader")
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isTranslucent = false
        
        
        verifiedIcon.isHidden = true
        profilePicture.isHidden = true
        bioLabel.isHidden = true
        fullName.isHidden = true
        Spotify.isHidden = true
        Contact.isHidden = true
        Instagram.isHidden = true
        Pinterest.isHidden = true
        SoundCloud.isHidden = true
        YouTube.isHidden = true
        Twitter.isHidden = true
        BlurView1.isHidden = true
        BlurView2.isHidden = true
        BlurView3.isHidden = true
        swapButton.isHidden = true
        
        
       MakeBlurViewCircular(blurView: BlurView1)
       MakeBlurViewCircular(blurView: BlurView2)
       MakeBlurViewCircular(blurView: BlurView3)
        
        usernameLabel.text = searchedUser
        
        
        SwapUser(username: searchedUser).getInformation { (error, user) in
       
             DispatchQueue.main.async {
            
            self.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
            circularImage(photoImageView: self.profilePicture)
                
            // Send the Twitter ID to the Twitter Preview View Controller 
            twitterUserID = user?._twitterID ?? ""
            
            self.fullName.text = ((user?._firstname)! + " " + (user?._lastname)!).uppercased()
                
            self.bioLabel.text = user?._bio
                
            self.pointsNumberLabel.text = "\(user?._points ?? 0)"
            self.swappedNumberLabel.text = "\(user?._swapped ?? 0)"
            self.swapsNumberLabel.text = "\(user?._swaps ?? 0)"
                
                //show the hidden views
                
                self.profilePicture.isHidden = false
                self.bioLabel.isHidden = false
                self.fullName.isHidden = false
                self.Spotify.isHidden = false
                self.Contact.isHidden = false
                self.Instagram.isHidden = false
                self.Pinterest.isHidden = false
                self.SoundCloud.isHidden = false
                self.YouTube.isHidden = false
                self.Twitter.isHidden = false
                self.BlurView1.isHidden = false
                self.BlurView2.isHidden = false
                self.BlurView3.isHidden = false
                self.swapButton.isHidden = false
                
            self.verifiedIcon.isHidden = !(user?._isVerified?.boolValue ?? false)
                
             //   self.Spotify.image = (user?._willShareSpotify?.boolValue ?? false) ? SpotifyLightImage : SpotifyLight
                
            self.Twitter.image = (user?._willShareTwitter?.boolValue ?? false) ? #imageLiteral(resourceName: "TwitterDark"): #imageLiteral(resourceName: "TwitterLight")
                
            self.Instagram.image = (user?._willShareInstagram?.boolValue ?? false) ? #imageLiteral(resourceName: "InstagramDark") : #imageLiteral(resourceName: "InstagramLight")
                
                
                
            let userWillAtLeastShareEmailOrPhoneNumber = (user?._willShareEmail?.boolValue ?? false) || (user?._willSharePhone?.boolValue ?? false)
            
            // self.Contact.image = userWillAtLeastShareEmailOrPhoneNumber ? #imageLiteral(resourceName: "ContactDark") : ContactLight
                
                self.loadingView.stopAnimating()
            
            }
        }

    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func MakeBlurViewCircular(blurView: UIVisualEffectView) -> UIVisualEffectView{
        
        blurView.layer.cornerRadius = blurView.frame.height/2
        blurView.layer.masksToBounds = false
        blurView.clipsToBounds = true
        blurView.contentMode = .scaleAspectFill
        blurView.layer.frame = blurView.layer.frame.insetBy(dx: 0, dy: 0)
        
        return blurView
    }
}
