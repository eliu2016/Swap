//
//  SelectProfilePictureViewController.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/8/16.
//
//

import UIKit

class SelectProfilePictureViewController: UIViewController {

    
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var instagramPictureImageView: UIImageView!
    
    
    @IBOutlet weak var twitterPictureImageView: UIImageView!
    
    
    @IBOutlet weak var youtubePictureImageView: UIImageView!
    
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var instagramButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var youTubeButton: UIButton!
    
  
    override func viewWillAppear(_ animated: Bool) {
        
        //Gathers profile pictures from social medias
        
        contactImageView.image = getContactImage() ?? #imageLiteral(resourceName: "DefaultProfileImage")
        
        if let instagramPic = getInstagramProfilePictureLink(){
            
             instagramPictureImageView.kf.setImage(with: instagramPic)
        }
        
        if let twitterPic = getTwitterProfilePictureLink(){
            
             twitterPictureImageView.kf.setImage(with: twitterPic)
        }
       
        if let youtubePic = getYouTubeProfilePictureLink(){
            
            youtubePictureImageView.kf.setImage(with: youtubePic)
        }
        
        
        circularImage(photoImageView: contactImageView)
        circularImage(photoImageView: instagramPictureImageView)
        circularImage(photoImageView: twitterPictureImageView)
        circularImage(photoImageView: youtubePictureImageView)
    
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveViewController(viewController: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func didSelectContactPhoto(_ sender: Any) {
        
        if let contactImage = contactImageView.image{
            
             let imageData = UIImageJPEGRepresentation(contactImage, 1.0)
            
            disableViewWhileLoading()
            
            SwapUser().uploadProfilePicture(withData: imageData!, completion: {_ in
                
                DispatchQueue.main.async {
                
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            })
        }
        
    }
    @IBAction func didSelectInstagramPhoto(_ sender: Any) {
        
       
        if let instagramProfileImageLink = getInstagramProfilePictureLink(){
            
             let link = "\(instagramProfileImageLink)"
            
            disableViewWhileLoading()
            
            SwapUser().set(ProfileImage: link,  DidSetInformation: {
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }

            })
        }
        
        
    }
    @IBAction func didSelectTwitterPhoto(_ sender: Any) {
        
        if let twitterProfileImageLink = getTwitterProfilePictureLink(){
            
            let link = "\(twitterProfileImageLink)"
            
            disableViewWhileLoading()
            
            SwapUser().set(ProfileImage: link,  DidSetInformation: {
                
                DispatchQueue.main.async {
                    
                    
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
                
            })
        }

    }
    
    @IBAction func didSelectYouTubePhoto(_ sender: Any) {
        
        if let youtubeLink = getYouTubeProfilePictureLink(){
            
              let link = "\(youtubeLink)"
            
            disableViewWhileLoading()
            
            SwapUser().set(ProfileImage: link,  DidSetInformation: {
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            })
        }
    }
    
    
    func disableViewWhileLoading(){
    
        //show loading UI
        view.addSubview(ShowLoadingOverlay().showBlackOverlay())
        view.addSubview(ShowLoadingOverlay().showLoadingSymbol(view: self.view))
        
        //disable buttons
        contactButton.isEnabled = false
        instagramButton.isEnabled = false
        twitterButton.isEnabled = false
        youTubeButton.isEnabled = false
        
        
    }
    

}


