//
//  ProfileViewController.swift
//  Swap
//
//  Created by Dr. Stephen, Ph.D on 12/8/16.

//  Editors: David Slakter
//

import UIKit
import Kingfisher
import Spring



class ProfileViewController: UIViewController, UITextFieldDelegate {

    
    //labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var swapsLabel: UILabel!
    @IBOutlet weak var swappedLabel: UILabel!
    @IBOutlet var pointsNumberLabel: UILabel!
    @IBOutlet var swapsNumberLabel: UILabel!
    @IBOutlet var swappedNumberLabel: UILabel!
    
   
    //image views
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var swapCodeImageView: UIImageView!
    @IBOutlet var GradientBottomLine: UIImageView!
    @IBOutlet var verifiedIcon: UIImageView!
   
    
    
    //buttons
    @IBOutlet weak var Spotify: UIButton!
    @IBOutlet weak var Phone: UIButton!
    @IBOutlet weak var Email: UIButton!
    @IBOutlet var Vimeo: UIButton!
    @IBOutlet var Twitter: UIButton!
    @IBOutlet var YouTube: UIButton!
    @IBOutlet var SoundCloud: UIButton!
    @IBOutlet var Pinterest: UIButton!
    @IBOutlet var Reddit: UIButton!
    @IBOutlet var Github: UIButton!
    @IBOutlet var Instagram: UIButton!
    @IBOutlet var infoIcon: UIButton!
    
    @IBOutlet var bioTextField: UITextField!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    

    @IBAction func didToggleSocialMediaPermission(_ sender: UIButton) {
        
        toogleSocialMedia(sender: sender)
        
    }
    
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadProfile()
        
        // Listens for reloadProfile notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadProfile), name: .reloadProfile, object: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //upload the updated user bio
        
        let Userbio = bioTextField.text
        SwapUser().set(Bio: Userbio)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        bioTextField.resignFirstResponder()
        return true
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
    
    /// Shows the loading symbol and reloads the profile data.
    func loadProfile()  {
        
        
        
        // Hide UI or do whatever to show that the profile is loading
        self.loadingIndicator.startAnimating()
        
        self.nameLabel.isHidden = true
        self.pointsLabel.isHidden = true
        self.swapsLabel.isHidden = true
        self.swappedLabel.isHidden = true
        self.pointsNumberLabel.isHidden = true
        self.swappedNumberLabel.isHidden = true
        self.swapsNumberLabel.isHidden = true
        self.GradientBottomLine.isHidden = true
        self.profilePicImageView.isHidden = true
        self.swapCodeImageView.isHidden = true
        self.Spotify.isHidden = true
        self.Phone.isHidden = true
        self.Email.isHidden = true
        self.Vimeo.isHidden = true
        self.Twitter.isHidden = true
        self.YouTube.isHidden = true
        self.SoundCloud.isHidden = true
        self.Pinterest.isHidden = true
        self.Reddit.isHidden = true
        self.Github.isHidden = true
        self.Instagram.isHidden = true
        self.bioTextField.isHidden = true
        self.infoIcon.isHidden = true
        self.verifiedIcon.isHidden = true
        
        
        //Gets info of signed in user
        //
        SwapUser(username: getUsernameOfSignedInUser()).getInformation(completion: { (error, user) in
            


            if error != nil{
                // There is an error
                // Note -- Micheal S. Bingham -- Should Handle this in the future
            }

                
            else{
                
                
                
                
                // Data is now loaded so stop any loading UI
                self.loadingIndicator.isHidden = true
                
                self.nameLabel.isHidden = false
                self.pointsLabel.isHidden = false
                self.swapsLabel.isHidden = false
                self.swappedLabel.isHidden = false
                self.pointsNumberLabel.isHidden = false
                self.swapsNumberLabel.isHidden = false
                self.swappedNumberLabel.isHidden = false
                self.GradientBottomLine.isHidden = false
                self.profilePicImageView.isHidden = false
                self.swapCodeImageView.isHidden = false
                self.Spotify.isHidden = false
                self.Phone.isHidden = false
                self.Email.isHidden = false
                self.Vimeo.isHidden = false // Change this to Reddit
                self.Twitter.isHidden = false
                self.YouTube.isHidden = false
                self.SoundCloud.isHidden = false
                self.Pinterest.isHidden = false
                self.Reddit.isHidden = false
                self.Github.isHidden = false
                self.Instagram.isHidden = false
                self.bioTextField.isHidden = false
                self.infoIcon.isHidden = false
                
                if (user?._isVerified?.boolValue ?? false){
                    
                    self.verifiedIcon.isHidden = false
                }
                
                
                
                //Gets the Profile Information from User Object
                let firstname = user?._firstname ?? ""
                let lastname = user?._lastname ?? ""
                let points = user?._points ?? 0
                let swaps = user?._swaps ?? 0
                let swapped = user?._swapped ?? 0
                let bio = user?._bio ?? ""
                let willShareSpotify = (user?._willShareSpotify as? Bool) ?? false
                let willShareEmail = (user?._willShareEmail as? Bool) ?? false
                let willSharePhone = (user?._willSharePhone as? Bool) ?? false
                let profileImageUrl = user?._profilePictureUrl ?? "http://www.american.edu/uploads/profiles/large/chris_palmer_profile_11.jpg"
                let swapCodeImageUrl = user?._swapCodeUrl ?? "https://dashboard.unitag.io/qreator/generate?setting=%7B%22LAYOUT%22%3A%7B%22COLORBG%22%3A%22ffffff%22%2C%22COLOR1%22%3A%221fbcd3%22%7D%2C%22EYES%22%3A%7B%22EYE_TYPE%22%3A%22Grid%22%7D%2C%22BODY_TYPE%22%3A5%2C%22E%22%3A%22H%22%2C%22LOGO%22%3A%7B%22L_NAME%22%3A%22https%3A%2F%2Fstatic-unitag.com%2Ffile%2Ffreeqr%2Fcfc031a5ddb114b66233e4e1762b93cb.png%22%2C%22EXCAVATE%22%3Atrue%2C%22L_X_Norm%22%3A0.4%2C%22L_Y_Norm%22%3A0.396%2C%22L_WIDTH%22%3A0.2%2C%22L_LENGTH%22%3A0.208%7D%7D&data=%7B%22TYPE%22%3A%22text%22%2C%22DATA%22%3A%7B%22TEXT%22%3A%22\(getUsernameOfSignedInUser())%22%2C%22URL%22%3A%22%22%7D%7D"
                
                
                // Updates UI
                self.nameLabel.text = "\(firstname) \(lastname)"
                self.bioTextField.text = "\(bio)"
                self.pointsNumberLabel.text = "\(points)"
                self.swapsNumberLabel.text = "\(swaps)"
                self.swappedNumberLabel.text = "\(swapped)"
                self.Spotify.isSelected = willShareSpotify
                self.Email.isSelected = willShareEmail
                self.Phone.isSelected = willSharePhone
                self.Reddit.isSelected = (user?._willShareReddit as? Bool) ?? false
                self.Instagram.isSelected = (user?._willShareInstagram as? Bool) ?? false
                self.Twitter.isSelected = (user?._willShareTwitter as? Bool) ?? false
                self.YouTube.isSelected = (user?._willShareYouTube as? Bool) ?? false
                self.SoundCloud.isSelected = (user?._willShareSoundCloud as? Bool) ?? false
                self.Pinterest.isSelected = (user?._willSharePinterest as? Bool) ?? false
                self.Vimeo.isSelected = (user?._willShareVimeo as? Bool) ?? false
                self.Github.isSelected = (user?._willShareGitHub as? Bool) ?? false
                self.profilePicImageView.kf.setImage(with: URL(string: profileImageUrl))
                circularImage(photoImageView: self.profilePicImageView)
                self.swapCodeImageView.kf.setImage(with: URL(string: swapCodeImageUrl))
                
                
                //Stop pull refresh here . 
                refreshControl.endRefreshing()
                
                if let notificationID = user?._notification_id_one_signal {
                    if notificationID == "0"{
                        
                        SwapUser().setUpPushNotifications()
                    }
                }
            }
            
            
            
        

    })
        
    }
    
    
    
    func setupViewController()  {
        
        DispatchQueue.main.async {
            
            slideLeft(label: self.nameLabel)
            slideRight(image: self.profilePicImageView)
            
        }
        
        saveViewController(viewController: nil)
        
        
        //set delegates
        bioTextField.delegate = self
        
        // CONFIGURING THE MAIN TAB BAR CONTROLLER
        tabBarController?.tabBar.backgroundImage = UIImage(named: "TabBarBackground")
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.tintColor = UIColor.init(red: 0, green: 144, blue: 255, alpha: 1.0)
        
        
        if #available(iOS 10.0, *) {
            tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        }
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
        
        // Set the selected photos for when the social media icons are toggled
        Spotify.setImage(#imageLiteral(resourceName: "SpotifyEnabled"), for: .selected)
        Email.setImage(#imageLiteral(resourceName: "EmailEnabled"), for: .selected)
        Phone.setImage(#imageLiteral(resourceName: "PhoneEnabled"), for: .selected)
        Reddit.setImage(#imageLiteral(resourceName: "RedditEnabled"), for: .selected)
        Instagram.setImage(#imageLiteral(resourceName: "InstagramEnabled"), for: .selected)
        Github.setImage(#imageLiteral(resourceName: "GithubEnabled"), for: .selected)
        Vimeo.setImage(#imageLiteral(resourceName: "VimeoEnabled"), for: .selected)
        Twitter.setImage(#imageLiteral(resourceName: "TwitterEnabled"), for: .selected)
        YouTube.setImage(#imageLiteral(resourceName: "YouTubeEnabled"), for: .selected)
        SoundCloud.setImage(#imageLiteral(resourceName: "SoundCloudEnabled"), for: .selected)
        Pinterest.setImage(#imageLiteral(resourceName: "PinterestEnabled"), for: .selected)
    }
    
    
    
    
    func toogleSocialMedia(sender: UIButton)  {
        
        sender.isSelected = !sender.isSelected
        
      switch sender  {
            
            
            case Spotify:
            
           
            
            SwapUser(username: getUsernameOfSignedInUser()
            ).set(WillShareSpotify: !sender.isSelected, DidSetInformation: {
            
         
            
            return nil
            
            
            })
            
            
            
            break
            
            
            case Phone:
            
           
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillSharePhonenumber: !sender.isSelected, DidSetInformation: {
            
           
            return nil
            
            
            })
            
            
            break
            
            
            case Email:
            
          
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareEmail: !sender.isSelected, DidSetInformation: {
            
           
            return nil
            
            
            })
            
            
            break
            
            
            
            
            case Reddit:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()
            ).set(WillShareReddit: !sender.isSelected, DidSetInformation: {
            
            
            return nil
            
            
            
            })
            
            
            
            break
            
            
            case Instagram:
            
       
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareInstagram: !sender.isSelected, DidSetInformation: {
            
          
            return nil
            
            
            })
            
            
            break
            
            
            case Twitter:
            
        
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareTwitter: !sender.isSelected, DidSetInformation: {
            
            
            return nil
            
            
            })
            
            
            break
            
            
            
            case YouTube:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()
            ).set(WillShareYouTube: !sender.isSelected, DidSetInformation: {
            
            
            return nil
            
            
            
            })
            
            
            
            break
            
            
            case SoundCloud:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareSoundCloud: !sender.isSelected, DidSetInformation: {
            
      
            return nil
            
            
            })
            
            
            break
            
            
            case Pinterest:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillSharePinterest: !sender.isSelected, DidSetInformation: {
            
           
            return nil
            
            
            })
            
            
            break
            
            
            case Vimeo:
            
   
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareVimeo: !sender.isSelected, DidSetInformation: {
            
            
            return nil
            
            
            })
            
            
            break
            
            
            case Github:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareGitHub: !sender.isSelected, DidSetInformation: {
            
           
            return nil
            
            
            })
            
            
            break
            
            
            default:
            break
        }
    }
    
    
}

func slideLeft(label: UILabel){
    
    let layer = label as! SpringLabel
    layer.animation = "squeezeLeft"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}

func slideRight(image: UIImageView){
    
    let layer = image as! SpringImageView
    layer.animation = "squeezRight"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
    
}



