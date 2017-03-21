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
    @IBOutlet weak var Reddit: UIImageView!
    @IBOutlet weak var GitHub: UIImageView!
    @IBOutlet weak var Vimeo: UIImageView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
   
    override func viewDidAppear(_ animated: Bool) {
        save(screen: .SearchedUserProfileScreen)
    }
    
    
    override func viewDidLoad() {
    
    
        setupViewController()
        loadProfile()
        
        // Listens for reloadSearchedUserProfile notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadProfile), name: .reloadSearchedUserProfile, object: nil)

    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
       exitProfile()
    }
    
    
    
    @IBAction func didTapSwap(_ sender: Any) {
        
       SwapUser().swap(with: searchedUser, authorizeOnViewController: self) { (error, user) in
        
        
        if let error = error{
            
            print("Error Trying to Swap");
            
        }
        else {
        
                if (user?._isPrivate as? Bool)!{
                    
                    self.makeSwapButtonRequested()
                }
    
                else{
                    
                    self.swapButton.isEnabled = false
                    self.swapButton.setTitleColor(UIColor.darkGray, for: .normal)
                    
                    let alert = UIAlertController(title: "Success", message: "You have just Swapped™ \(user?._firstname!) \(user?._lastname!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
       
        }
        
        
    }
    
    func makeSwapButtonRequested(){
     
        self.swapButton.isEnabled = false
        self.swapButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.swapButton.setBackgroundImage(#imageLiteral(resourceName: "RequestedSwapButton"), for: .normal)
        self.swapButton.setTitle("Requested", for: .normal)
        self.swapButton.frame = CGRect(x: self.swapButton.frame.origin.x - 12, y: self.swapButton.frame.origin.y, width: self.swapButton.frame.width + 26, height: self.swapButton.frame.height)
    }
    
    func MakeBlurViewCircular(blurView: UIVisualEffectView) -> UIVisualEffectView{
        
        blurView.layer.cornerRadius = blurView.frame.height/2
        blurView.layer.masksToBounds = false
        blurView.clipsToBounds = true
        blurView.contentMode = .scaleAspectFill
        blurView.layer.frame = blurView.layer.frame.insetBy(dx: 0, dy: 0)
        
        return blurView
    }
    
    
    
    
    
    func setupViewController()  {
        
        
        self.tabBarController?.tabBar.backgroundImage = #imageLiteral(resourceName: "Subheader")
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor.black
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
        GitHub.isHidden = true
        Vimeo.isHidden = true
        Reddit.isHidden = true
        BlurView1.isHidden = true
        BlurView2.isHidden = true
        BlurView3.isHidden = true
        swapButton.isHidden = true
        
        
        MakeBlurViewCircular(blurView: BlurView1)
        MakeBlurViewCircular(blurView: BlurView2)
        MakeBlurViewCircular(blurView: BlurView3)
        
        usernameLabel.text = searchedUser
    }
    
    
    
    
    
    
    
    func loadProfile()  {
        
        self.loadingView.startAnimating()
        
        SwapUser(username: searchedUser).getInformation { (error, user) in
            
            
            guard error == nil else{
                
                self.performSegue(withIdentifier: "fromSearchUsersToProfile", sender: nil)
                
                return
            }
            
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
                
                
                
                if (user?._isPrivate as? Bool)!{
                    
                    //change to private swap button
                   // self.swapButton.setBackgroundImage(#imageLiteral(resourceName: "PrivateSwapButton"), for: .normal)
                    self.swapButton.frame = CGRect(x: self.swapButton.frame.origin.x, y: self.swapButton.frame.origin.y, width: self.swapButton.frame.width + 13, height: self.swapButton.frame.height)
                    self.swapButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 10)
                    
                    
                    SwapUser(username: getUsernameOfSignedInUser()).getPendingSentSwapRequests(result: { (error, requests) in
                        
                        if let error = error{
                            
                            print(error.localizedDescription)
                            
                        }
                        else{
                            for user in requests! {
                                
                                if (user._requested == searchedUser){
                                    self.makeSwapButtonRequested()
                                }
                            }
                        }
                    })
                    
                    
                    
                }
                
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
                self.GitHub.isHidden = false
                self.Vimeo.isHidden = false
                self.Reddit.isHidden = false
                self.BlurView1.isHidden = false
                self.BlurView2.isHidden = false
                self.BlurView3.isHidden = false
                self.swapButton.isHidden = false
                
                self.verifiedIcon.isHidden = !(user?._isVerified?.boolValue ?? false)
                
                self.Spotify.image = (user?._willShareSpotify?.boolValue ?? false && !(user?._spotifyID ?? "").isEmpty) ? #imageLiteral(resourceName: "SpotifyDark") : #imageLiteral(resourceName: "SpotifyLight")
                
                self.Twitter.image = (user?._willShareTwitter?.boolValue ?? false && !(user?._twitterID ?? "").isEmpty) ? #imageLiteral(resourceName: "TwitterDark"): #imageLiteral(resourceName: "TwitterLight")
                
                self.Instagram.image = (user?._willShareInstagram?.boolValue ?? false && !(user?._instagramID ?? "").isEmpty) ? #imageLiteral(resourceName: "InstagramDark") : #imageLiteral(resourceName: "InstagramLight")
                
                self.Reddit.image = (user?._willShareReddit?.boolValue ?? false && !(user?._redditID ?? "").isEmpty) ? #imageLiteral(resourceName: "RedditDark") : #imageLiteral(resourceName: "RedditLight")
                
                self.GitHub.image = (user?._willShareGitHub?.boolValue ?? false && !(user?._githubID ?? "").isEmpty) ? #imageLiteral(resourceName: "GithubDark"): #imageLiteral(resourceName: "GithubLight")
                
                self.Vimeo.image = (user?._willShareVimeo?.boolValue ?? false && !(user?._vimeoID ?? "").isEmpty) ? #imageLiteral(resourceName: "VimeoDark") : #imageLiteral(resourceName: "VimeoLight")
                
                
                self.YouTube.image = (user?._willShareYouTube?.boolValue ?? false && !(user?._youtubeID ?? "").isEmpty) ? #imageLiteral(resourceName: "YoutubeDark") : #imageLiteral(resourceName: "YoutubeLight")
                
                self.SoundCloud.image = (user?._willShareSoundCloud?.boolValue ?? false && !(user?._soundcloudID ?? "").isEmpty) ? #imageLiteral(resourceName: "SoundCloudDark") : #imageLiteral(resourceName: "SoundCloudLight")
                
                self.Pinterest.image = (user?._willSharePinterest?.boolValue ?? false && !(user?._pinterestID ?? "").isEmpty) ? #imageLiteral(resourceName: "PinterestDark") : #imageLiteral(resourceName: "PinterestLight")
                
                let userWillAtLeastShareEmailOrPhoneNumber = (user?._willShareEmail?.boolValue ?? false) || (user?._willSharePhone?.boolValue ?? false)
                
                self.Contact.image = userWillAtLeastShareEmailOrPhoneNumber ? #imageLiteral(resourceName: "ContactDark") : #imageLiteral(resourceName: "ContactLight")
                
                self.loadingView.stopAnimating()
                
            }
        }
    }
    
    
    
    
    
    
    
    func exitProfile()  {
        
        if self.presentingViewController == nil{
            
            self.performSegue(withIdentifier: "fromSearchUsersToProfile", sender: nil)
            
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
}
