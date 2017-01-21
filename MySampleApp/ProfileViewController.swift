//
//  ProfileViewController.swift
//  Swap
//
//  Created by Dr. Stephen, Ph.D on 12/8/16.

//  Editors: David Slakter
//

import UIKit
import Kingfisher



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
    @IBOutlet var profilePicBorder: UIImageView!
    @IBOutlet weak var swapCodeImageView: UIImageView!
    @IBOutlet var GradientBottomLine: UIImageView!
    
    
    //buttons
    @IBOutlet weak var Spotify: UIButton!
    @IBOutlet weak var Phone: UIButton!
    @IBOutlet weak var Email: UIButton!
    @IBOutlet var Snapchat: UIButton!
    @IBOutlet var Twitter: UIButton!
    @IBOutlet var YouTube: UIButton!
    @IBOutlet var SoundCloud: UIButton!
    @IBOutlet var Pinterest: UIButton!
    @IBOutlet var Vine: UIButton!
    @IBOutlet var Facebook: UIButton!
    @IBOutlet var Instagram: UIButton!

    
    @IBOutlet var bioTextField: UITextField!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    

    @IBAction func didToggleSocialMediaPermission(_ sender: UIButton) {
        
        
    switch sender {
            
            
        case Spotify:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()
                    ).set(WillShareSpotify: !sender.isSelected, DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            sender.isSelected = !sender.isSelected
                            
                        }
                        
                    })
            }
            
            
            break
            
            
        case Phone:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()).set(WillSharePhonenumber: !sender.isSelected, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        sender.isSelected = !sender.isSelected
                    }
                    
                })
            }
            
            break
            
            
        case Email:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()).set(WillShareEmail: !sender.isSelected, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        sender.isSelected = !sender.isSelected
                    }
                    
                })
            }
            
            break
            
            
            
            
        case Vine:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()
                    ).set(WillShareVine: !sender.isSelected, DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            sender.isSelected = !sender.isSelected
                            
                        }
                        
                    })
            }
            
            
            break
            
            
        case Instagram:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()).set(WillShareInstagram: !sender.isSelected, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        sender.isSelected = !sender.isSelected
                    }
                    
                })
            }
            
            break
            
            
        case Twitter:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()).set(WillShareTwitter: !sender.isSelected, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        sender.isSelected = !sender.isSelected
                    }
                    
                })
            }
            
            break
            
            
            
        case YouTube:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()
                    ).set(WillShareYouTube: !sender.isSelected, DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            sender.isSelected = !sender.isSelected
                            
                        }
                        
                    })
            }
            
            
            break
            
            
        case SoundCloud:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()).set(WillShareSoundCloud: !sender.isSelected, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        sender.isSelected = !sender.isSelected
                    }
                    
                })
            }
            
            break
            
            
        case Pinterest:
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                SwapUser(username: getUsernameOfSignedInUser()).set(WillSharePinterest: !sender.isSelected, DidSetInformation: {
                    
                    DispatchQueue.main.async {
                        sender.isSelected = !sender.isSelected
                    }
                    
                })
            }
            
            break
            
            
        default:
            break
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
 
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveViewController(viewController: nil)
        
        // Loads profile data from API on a high priority background thread
        DispatchQueue.global(qos: .userInitiated).async {
            
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
            self.profilePicBorder.isHidden = true
            self.swapCodeImageView.isHidden = true
            self.Spotify.isHidden = true
            self.Phone.isHidden = true
            self.Email.isHidden = true
            self.Snapchat.isHidden = true
            self.Twitter.isHidden = true
            self.YouTube.isHidden = true
            self.SoundCloud.isHidden = true
            self.Pinterest.isHidden = true
            self.Vine.isHidden = true
            self.Facebook.isHidden = true
            self.Instagram.isHidden = true
            
            
            
            //Gets info of signed in user
            //
            SwapUser(username: getUsernameOfSignedInUser()).getInformation(completion: { (error, user) in
                
                if error != nil{
                    // There is an error
                    // Note -- Micheal S. Bingham -- Should Handle this in the future
                }
                    
                else{
                    // Now goes to main UI Thread
                    
                    DispatchQueue.main.async(execute: {
                        
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
                        self.profilePicBorder.isHidden = false
                        self.swapCodeImageView.isHidden = false
                        self.Spotify.isHidden = false
                        self.Phone.isHidden = false
                        self.Email.isHidden = false
                        self.Snapchat.isHidden = false
                        self.Twitter.isHidden = false
                        self.YouTube.isHidden = false
                        self.SoundCloud.isHidden = false
                        self.Pinterest.isHidden = false
                        self.Vine.isHidden = false
                        self.Facebook.isHidden = false
                        self.Instagram.isHidden = false
                        
                        
                        
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
                        self.profilePicImageView.kf.setImage(with: URL(string: profileImageUrl))
                        self.swapCodeImageView.kf.setImage(with: URL(string: swapCodeImageUrl))
                        
                        
                    })
                    
                    
                }
                
                
                
            })
            
        }
        
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
        Spotify.setImage(UIImage(named: "SpotifyEnabled"), for: .selected)
        Email.setImage(UIImage(named: "EmailEnabled"), for: .selected)
        Phone.setImage(UIImage(named: "PhoneEnabled"), for: .selected)
        Vine.setImage(UIImage(named: "VineEnabled"), for: .selected)
        Instagram.setImage(UIImage(named: "InstagramEnabled"), for: .selected)
        Facebook.setImage(UIImage(named: "FacebookEnabled"), for: .selected)
        Snapchat.setImage(UIImage(named: "SnapchatEnabled"), for: .selected)
        Twitter.setImage(UIImage(named: "TwitterEnabled"), for: .selected)
        YouTube.setImage(UIImage(named: "YouTubeEnabled"), for: .selected)
        SoundCloud.setImage(UIImage(named: "SoundCloudEnabled"), for: .selected)
        Pinterest.setImage(UIImage(named: "PinterestEnabled"), for: .selected)

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //upload the updated user bio
        
        print("did end editing")
        let Userbio = bioTextField.text
        SwapUser().set(Bio: Userbio)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
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
}

