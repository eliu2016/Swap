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
import Alamofire


class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    
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
    @IBOutlet var Topper: UIImageView!
   
    
    
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
    
    @IBAction func didTapProfilePic(_ sender: Any) {
        
            let actionSheeet = UIAlertController(title: "Change Picture", message: nil, preferredStyle: .actionSheet)
        
            actionSheeet.addAction(UIAlertAction(title: "Upload Picture", style: .default, handler: { (action) in
            
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
                
            }))
        
            actionSheeet.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { (alert) in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }))
        
           actionSheeet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
           present(actionSheeet, animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        setupViewController()
        loadProfile()
        setupSwapCodeGestureRecognizer()
        
        // Listens for reloadProfile notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadProfile), name: .reloadProfile, object: nil)
        
        if !UserDefaults.standard.bool(forKey: "didShowTutorial"){
           
            self.performSegue(withIdentifier: "showTutorial", sender: nil)
    
        }
        
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
           save(screen: .UserProfileScreen)

    
     
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


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            
            DispatchQueue.main.async {
                
                SwapUser().uploadProfilePicture(withData: imageData!, completion: { (error) in
                
                })
                
            }
                NotificationCenter.default.post(name: .reloadProfile, object: nil)
            
        }
        else{
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imageData = UIImageJPEGRepresentation(image!, 1.0)
            DispatchQueue.main.async {
                
                SwapUser().uploadProfilePicture(withData: imageData!, completion: { (error) in
                    
                })
                
            
            }
        
            NotificationCenter.default.post(name: .reloadProfile, object: nil)
        
        }
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
        
        loadSwapAndSwapHistoryInBackground()
        
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
                refreshControl.endRefreshing()
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
                let swapCodeImageUrl =   "https://unitag-qr-code-generation.p.mashape.com/api?setting=%7B%22LAYOUT%22%3A%7B%22COLORBG%22%3A%22transparent%22%2C%22COLOR1%22%3A%22262626%22%7D%2C%22EYES%22%3A%7B%22EYE_TYPE%22%3A%22Grid%22%7D%2C%22BODY_TYPE%22%3A5%2C%22E%22%3A%22H%22%2C%22LOGO%22%3A%7B%22L_NAME%22%3A%22https%3A%2F%2Fstatic-unitag.com%2Ffile%2Ffreeqr%2F38436a5c234f2c0817f2e83903d33287.png%22%2C%22EXCAVATE%22%3Atrue%7D%7D&data=%7B%22TYPE%22%3A%22text%22%2C%22DATA%22%3A%7B%22TEXT%22%3A%22http%3A%2F%2Fgetswap.me%2F\(getUsernameOfSignedInUser())%22%2C%22URL%22%3A%22%22%7D%7D"
                
                
                // Updates UI
                self.nameLabel.text = "\(firstname) \(lastname)"
                self.bioTextField.text = "\(bio)"
                self.pointsNumberLabel.text = "\(points)"
                self.swapsNumberLabel.text = "\(swaps ?? 0)"
                self.swappedNumberLabel.text = "\(swapped ?? 0)"
                
               
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
                self.profilePicImageView.kf.indicatorType = .activity
                self.profilePicImageView.kf.setImage(with: URL(string: profileImageUrl))
                circularImageNoBorder(photoImageView: self.profilePicImageView)
                self.setupSwapCodeImage()
                    
                    
                    
                
                
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
    
    
    
    func loadSwapAndSwapHistoryInBackground()  {
        swapHistoryUsers.removeAll()
        swappedHistoryUsers.removeAll()
        
        DispatchQueue.global(qos: .background).async {
            
            
            SwapUser().getSwapHistory(result: { (error, history) in
                
                DispatchQueue.main.async {
                    
                    let swaps =  history?.count
         
                    swapHistoryUsers = history ?? []
                    
                   print("\n\n\n\n The Swap History is : \(swapHistoryUsers)")
                }
                
            })
            
            SwapUser().getSwappedHistory(result: { (error, history) in
                
                DispatchQueue.main.async {
                    
                    let swapped = history?.count
           
                    swappedHistoryUsers = history ?? []
                    
                     print("\n\n\n\n The Swapped History is : \(swapHistoryUsers)")
                }
              
                
            })
        }
        
        
    }
    
    
    
    func setupViewController()  {
        
        removePlaceHoldersAndAdjustFontsByLabelWidth()
        
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
        
        
        //set up nav controller
        let navBar = self.navigationController?.navigationBar
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        navBar?.setBackgroundImage(#imageLiteral(resourceName: "Header1"), for: .default)
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next Ultra Light", size: 21)!]
        navBar?.tintColor = UIColor.white
        //navBar?.isTranslucent = false
        
        
        let topper = UIImageView(image: #imageLiteral(resourceName: "RoundWhiteTopper"))
        topper.frame = Topper.frame
        self.navigationController?.view.addSubview(topper)
    
        
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
        
        let status: Bool = !sender.isSelected
        sender.isSelected = !sender.isSelected
        
      switch sender  {
            
            
            case Spotify:
            
            
           
            
            SwapUser(username: getUsernameOfSignedInUser()
            ).set(WillShareSpotify: status, DidSetInformation: {
            
         
            
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            
            break
            
            
            case Phone:
            
           
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillSharePhonenumber: status, DidSetInformation: {
            
           
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            case Email:
            
          
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareEmail: status, DidSetInformation: {
            
           
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            
            
            case Reddit:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()
            ).set(WillShareReddit: status, DidSetInformation: {
            
            
            return nil
            
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            
            break
            
            
            case Instagram:
            
       
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareInstagram: status, DidSetInformation: {
            
          
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            case Twitter:
            
        
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareTwitter: status, DidSetInformation: {
            
            
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            
            case YouTube:
                

            
               
            
            SwapUser(username: getUsernameOfSignedInUser()
            ).set(WillShareYouTube: status, DidSetInformation: {
            
            
            return nil
            
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            
            break
            
            
            case SoundCloud:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareSoundCloud: status, DidSetInformation: {
            
      
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            case Pinterest:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillSharePinterest: status, DidSetInformation: {
            
           
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            case Vimeo:
            
   
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareVimeo: status, DidSetInformation: {
            
            
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            case Github:
            
            
            
            SwapUser(username: getUsernameOfSignedInUser()).set(WillShareGitHub: status, DidSetInformation: {
            
           
            return nil
            
            
            }, CannotSetInformation: {
                
                sender.isSelected = !sender.isSelected
            })
            
            
            break
            
            
            default:
            break
        }
    }
    
    /// Sets up the gesture recognizer for the Swap Code
    func setupSwapCodeGestureRecognizer()  {
        
        swapCodeImageView.isUserInteractionEnabled = true
      
        //now you need a tap gesture recognizer
        //note that target and action point to what happens when the action is recognized.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.doubleTappedSwapCode(_:)))
        tapRecognizer.numberOfTapsRequired = 2
        //Add the recognizer to your view.
        swapCodeImageView.addGestureRecognizer(tapRecognizer)
    }
    
    /// Called when the Swap Code is Double Tapped. Should turn on/off all permissions.
    func doubleTappedSwapCode(_ gestureRecognizer: UITapGestureRecognizer) {
        
        var countOfTrue = 0
    
        let buttons: [UIButton] = [Reddit, Spotify, Phone, Email, Instagram, Github, Vimeo, Twitter, YouTube, SoundCloud, Pinterest]
        
        for button in buttons{
            if button.isSelected  {
                
                countOfTrue += 1
            }
        }
        
        if countOfTrue >= 6 {
            
            // More enabled buttons than disabled  so turn off all
            
            // Toggle Permissions
            toggleAllPermissions(as: false)
            
        } else{
            // turn on
            
            // Toggle Permissions
            toggleAllPermissions(as: true)
        }
        
        
    }
    
    /// Turns on/off all permissions in database and in UI.
    func toggleAllPermissions(as state: Bool)  {
        
        
        SwapUser().set( WillShareSpotify: state, WillShareYouTube: state, WillSharePhonenumber: state, WillShareVine: state, WillShareInstagram: state, WillShareTwitter: state, WillShareEmail: state, WillShareReddit: state, WillSharePinterest: state, WillShareSoundCloud: state, WillShareGitHub: state, WillShareVimeo: state, DidSetInformation:{
            
            // Turn on all buttons
            
           self.toggleAllButtons(as: state)
            
        })
    }
    
    
    
    /// Toggles buttons on or off given the state. Does NOT alter information in database!
    func toggleAllButtons(as state:  Bool)  {
        
        Reddit.isSelected = state
        Spotify.isSelected = state
        Phone.isSelected = state
        Email.isSelected = state
        Instagram.isSelected = state
        Github.isSelected = state
        Vimeo.isSelected = state
        Twitter.isSelected = state
        YouTube.isSelected = state
        SoundCloud.isSelected = state
        Pinterest.isSelected = state
        
    }
    
    
    func removePlaceHoldersAndAdjustFontsByLabelWidth()  {
        
        nameLabel.shouldHidePlaceholderText = true
        nameLabel.adjustsFontSizeToFitWidth = true
        pointsNumberLabel.adjustsFontSizeToFitWidth = true
        swapsNumberLabel.adjustsFontSizeToFitWidth = true
        swappedNumberLabel.adjustsFontSizeToFitWidth = true
    }
    
    
   
    
    func setupSwapCodeImage()  {
        print("the username of the signed in user is ... \(getUsernameOfSignedInUser())")
       self.swapCodeImageView.kf.indicatorType = .activity
        
        //determines the color of the swap codese
        let SwapCodeColorBlue = UserDefaults.standard.bool(forKey: "SwapCodeColorBlue")
        
        
        
        // Try to use old url first
        print("trying to use old url")
    
        swapCodeImageView.kf.setImage(with: URL(string:defaultSwapCodeImageURL), placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
            
            if let error = error{
               print("Can't use old url")
                // Could not set it up with old url so try the paid version
                
                if let swapCodeImage = getSwapCodeImage(){
                    
                    print("there is a swap code image saved")
                    
                    self.swapCodeImageView.image = swapCodeImage
                    
                    
                } else{
                    
                    print("there is no swap code image saved")
                    
                    // Download Swap Code Image, Set it in Database
                    
                    let newSwapCodeImageURL = "https://unitag-qr-code-generation.p.mashape.com/api?setting=%7B%22LAYOUT%22%3A%7B%22COLORBG%22%3A%22transparent%22%2C%22COLOR1%22%3A%22262626%22%7D%2C%22EYES%22%3A%7B%22EYE_TYPE%22%3A%22Grid%22%7D%2C%22BODY_TYPE%22%3A5%2C%22E%22%3A%22H%22%2C%22LOGO%22%3A%7B%22L_NAME%22%3A%22https%3A%2F%2Fstatic-unitag.com%2Ffile%2Ffreeqr%2F38436a5c234f2c0817f2e83903d33287.png%22%2C%22EXCAVATE%22%3Atrue%7D%7D&data=%7B%22TYPE%22%3A%22text%22%2C%22DATA%22%3A%7B%22TEXT%22%3A%22http%3A%2F%2Fgetswap.me%2F\(getUsernameOfSignedInUser())%22%2C%22URL%22%3A%22%22%7D%7D"
                    
                    // Set the image by calling HTTP Request
                    
                    let header: HTTPHeaders = ["X-Mashape-Key": "LGS7uxKBdpmshrncdYMPTJCyqHpQp12twK7jsngjVN27Edbcpe"]
                    
                    Alamofire.request(newSwapCodeImageURL, method: .get, parameters: nil, headers: header).responseData(completionHandler: { (data) in
                        
                        if let data = data.data{
                            
                            // Save Data
                            save(swapCodeImageData: data)
                            self.swapCodeImageView.image = UIImage(data: data)
                            
                            
                            
                        }
                        
                    })
                    
                }

                
                
            } else{
                print("can use old url")
            }
           
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


/// The 'free version' of the Swap Code URL Image via API

let defaultSwapCodeImageURL = "https://dashboard.unitag.io/qreator/generate?setting=%7B%22LAYOUT%22%3A%7B%22COLORBG%22%3A%22transparent%22%2C%22COLOR1%22%3A%22262626%22%7D%2C%22EYES%22%3A%7B%22EYE_TYPE%22%3A%22Grid%22%7D%2C%22BODY_TYPE%22%3A5%2C%22E%22%3A%22H%22%2C%22LOGO%22%3A%7B%22L_NAME%22%3A%22https%3A%2F%2Fstatic-unitag.com%2Ffile%2Ffreeqr%2F38436a5c234f2c0817f2e83903d33287.png%22%2C%22EXCAVATE%22%3Atrue%7D%7D&data=%7B%22TYPE%22%3A%22text%22%2C%22DATA%22%3A%7B%22TEXT%22%3A%22http%3A%2F%2Fgetswap.me%2F\(getUsernameOfSignedInUser())%22%2C%22URL%22%3A%22%22%7D%7D"




/// The Paid version of the Swap Code URL Image via API
let version2SwapCodeURL = "https://unitag-qr-code-generation.p.mashape.com/api?setting=%7B%22LAYOUT%22%3A%7B%22COLORBG%22%3A%22ffffff%22%2C%22COLOR1%22%3A%2203E4F3%22%7D%2C%22EYES%22%3A%7B%22EYE_TYPE%22%3A%22Grid%22%7D%2C%22BODY_TYPE%22%3A5%2C%22E%22%3A%22H%22%2C%22LOGO%22%3A%7B%22L_NAME%22%3A%22https%3A%2F%2Fstatic-unitag.com%2Ffile%2Ffreeqr%2Fe70b5ccd3ca5554615433abeae699420.png%22%2C%22EXCAVATE%22%3Atrue%7D%7D&data=%7B%22TYPE%22%3A%22text%22%2C%22DATA%22%3A%7B%22TEXT%22%3A%22http://getswap.me/\(getUsernameOfSignedInUser())%22%2C%22URL%22%3A%22%22%7D%7D"

