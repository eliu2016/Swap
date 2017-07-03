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

class SearchedUser: UIViewController, UITabBarControllerDelegate {
    
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
    
    @IBOutlet var media1: UIImageView!
    @IBOutlet var media2: UIImageView!
    @IBOutlet var media3: UIImageView!
    @IBOutlet var media4: UIImageView!
    @IBOutlet var media5: UIImageView!
    @IBOutlet var media6: UIImageView!
    @IBOutlet var media7: UIImageView!
    @IBOutlet var media8: UIImageView!
    @IBOutlet var media9: UIImageView!
    @IBOutlet var media10: UIImageView!
  
    
    @IBOutlet var popUp: UIView!
 
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    var activeMediaArray = [UIImage]()
    
   
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
        
        SwapUser().swap(with: searchedUser, authorizeOnViewController: self, method: .username) { (error, user) in
        
        
        if let error = error{
            
            print("Error Trying to Swap");
            
        }
        else {
            
            DispatchQueue.main.async{
        
                if (user?._isPrivate as? Bool)!{
                    
                    self.makeSwapButtonRequested()
                }
    
                else{
                    
                    self.disableSwapButton()
                    self.showPopUp()
                    
                    
                    // Add Swap Points
                    let swap = SwapUser()
                    let swapped = SwapUser(username: user?._username ?? "")
                    
                    SwapUser.giveSwapPointsToUsersWhoSwapped(swap: swap, swapped: swapped)
                }
                
            }
            
        }
       
        }
        
        
    }
    
    func makeSwapButtonRequested(){
     
        self.swapButton.isEnabled = false
        self.swapButton.titleLabel?.alpha = 0.4
        self.swapButton.setBackgroundImage(#imageLiteral(resourceName: "RequestedSwapButton"), for: .normal)
        self.swapButton.setTitle("Requested", for: .normal)
        self.swapButton.frame = CGRect(x: self.swapButton.frame.origin.x - 12, y: self.swapButton.frame.origin.y, width: self.swapButton.frame.width + 26, height: self.swapButton.frame.height)
    }
    func disableSwapButton (){
        
        self.swapButton.isEnabled = false
        self.swapButton.titleLabel?.alpha = 0.4
    }
    
    func showPopUp(){
        
        UIView.animate(withDuration: 0.4, animations: {
            
             self.popUp.transform = CGAffineTransform.init(translationX: 0, y: -400)
            
        
        }) { (completed) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: { () -> Void in
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    
                    self.popUp.alpha = 0
                    
                })
            })
        }
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
        
        self.tabBarController?.tabBar.backgroundImage = #imageLiteral(resourceName: "Header1")
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.isTranslucent = false
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        self.tabBarController?.delegate = self
        
        
        verifiedIcon.isHidden = true
        profilePicture.isHidden = true
        bioLabel.isHidden = true
        fullName.isHidden = true
        media1.isHidden = true
        media2.isHidden = true
        media3.isHidden = true
        media4.isHidden = true
        media5.isHidden = true
        media6.isHidden = true
        media7.isHidden = true
        media8.isHidden = true
        media9.isHidden = true
        media10.isHidden = true
        BlurView1.isHidden = true
        BlurView2.isHidden = true
        BlurView3.isHidden = true
        swapButton.isHidden = true
        
        
        MakeBlurViewCircular(blurView: BlurView1)
        MakeBlurViewCircular(blurView: BlurView2)
        MakeBlurViewCircular(blurView: BlurView3)
        
        self.view.addSubview(popUp)
        popUp.backgroundColor = UIColor.clear
        popUp.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 400)
        
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
                
                self.profilePicture.kf.indicatorType = .activity
                self.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                circularImage(photoImageView: self.profilePicture)
                
                // Set the Twitter ID to the Twitter Preview View Controller
                twitterUserID = user?._twitterID ?? ""
                
                // Set the Instagram ID
                instagramUserID = user?._instagramID ?? ""
                
                //set the youtube ID
                YouTubeUserID = user?._youtubeID ?? ""
                
                YouTubePreviewUser = user
                
                instagramPreviewUser = user
                
                self.fullName.text = ((user?._firstname)! + " " + (user?._lastname)!).uppercased()
                
                self.bioLabel.text = user?._bio
                self.swapsNumberLabel.text = "\(user?._swaps ?? 0)"
                
                 self.swappedNumberLabel.text = "\(user?._swapped ?? 0)"
                
                
                self.pointsNumberLabel.text = "\(user?._points ?? 0)"
              
                
                //check if the searched user is the signed in user
                if searchedUser == getUsernameOfSignedInUser() {
                    
                    self.disableSwapButton()
                    
                }
            
                
                if (user?._isPrivate as? Bool)!{
                    
                    //change to private swap button
                    self.swapButton.setBackgroundImage(#imageLiteral(resourceName: "PrivateSwapButton"), for: .normal)
                    self.swapButton.frame = CGRect(x: self.swapButton.frame.origin.x, y: self.swapButton.frame.origin.y, width: self.swapButton.frame.width + 13, height: self.swapButton.frame.height)
                    self.swapButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 10)
                    
                    
                   
                        //check if the searched user has a pending swap by the signed in user.
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
                self.BlurView1.isHidden = false
                self.BlurView2.isHidden = false
                self.BlurView3.isHidden = false
                self.swapButton.isHidden = false
            
                
                self.verifiedIcon.isHidden = !(user?._isVerified?.boolValue ?? false)
                
                if (user?._willShareTwitter?.boolValue ?? false) && !((user?._twitterID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "TwitterLight"))
                }
                if (user?._willShareInstagram?.boolValue ?? false) && !((user?._instagramID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "InstagramLight"))
                }
                if (user?._willShareSpotify?.boolValue ?? false) && !((user?._spotifyID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "SpotifyLight"))
                }
                if (user?._willShareEmail?.boolValue ?? false) || (user?._willSharePhone?.boolValue ?? false){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "ContactLight"))
                }
                if (user?._willSharePinterest?.boolValue ?? false) && !((user?._pinterestID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "PinterestLight"))
                }
                if (user?._willShareYouTube?.boolValue ?? false) && !((user?._youtubeID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "YoutubeLight"))
                }
                if (user?._willShareSoundCloud?.boolValue ?? false) && !((user?._soundcloudID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "SoundCloudLight"))
                }
                if (user?._willShareVimeo?.boolValue ?? false) && !((user?._vimeoID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "VimeoLight"))
                }
                if (user?._willShareGitHub?.boolValue ?? false) && !((user?._githubID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "GithubLight"))
                }
                if (user?._willShareReddit?.boolValue ?? false) && !((user?._redditID ?? "") == ""){
                    
                    self.activeMediaArray.append(#imageLiteral(resourceName: "RedditLight"))
                }
                if self.activeMediaArray.indices.contains(0){
                    self.media1.image = self.activeMediaArray[0]
                    self.media1.isHidden = false
                }
                else{
                    self.disableSwapButton()
                }
                self.addMedia(media: self.media2, index: 1)
                self.addMedia(media: self.media3, index: 2)
                self.addMedia(media: self.media4, index: 3)
                self.addMedia(media: self.media5, index: 4)
                self.addMedia(media: self.media6, index: 5)
                self.addMedia(media: self.media7, index: 6)
                self.addMedia(media: self.media8, index: 7)
                self.addMedia(media: self.media9, index: 8)
                self.addMedia(media: self.media10, index: 9)
                
                if !(self.activeMediaArray.count % 2 == 0){
                    
                    self.media1.frame.origin.x = self.media1.frame.origin.x + 10
                    self.media2.frame.origin.x = self.media2.frame.origin.x + 10
                    self.media3.frame.origin.x = self.media3.frame.origin.x + 10
                    self.media4.frame.origin.x = self.media4.frame.origin.x + 10
                    self.media5.frame.origin.x = self.media5.frame.origin.x + 10
                    self.media6.frame.origin.x = self.media6.frame.origin.x + 10
                    self.media7.frame.origin.x = self.media7.frame.origin.x + 10
                    self.media8.frame.origin.x = self.media8.frame.origin.x + 10
                    self.media9.frame.origin.x = self.media9.frame.origin.x + 10
                    self.media10.frame.origin.x = self.media10.frame.origin.x + 10
                }
                
                self.loadingView.stopAnimating()
                
            }
        }
    }
    func addMedia(media: UIImageView, index: Int){
        
        if self.activeMediaArray.indices.contains(index){
            media.image = self.activeMediaArray[index]
            media.isHidden = false
        }
    }
    
    func exitProfile()  {
        
        UITabBar.appearance().layer.borderWidth = 1.0
        UITabBar.appearance().clipsToBounds = false
        
        if self.presentingViewController == nil{
            
            self.performSegue(withIdentifier: "fromSearchUsersToProfile", sender: nil)
            
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.viewControllers?.index(of: viewController) == 0{
            tabBarController.tabBar.backgroundImage = #imageLiteral(resourceName: "Header1")
        }
        else{
            tabBarController.tabBar.backgroundImage = #imageLiteral(resourceName: "TextfieldBottom")
        }
    }
    
}
