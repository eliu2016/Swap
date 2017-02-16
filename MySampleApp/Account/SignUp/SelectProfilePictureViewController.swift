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
        
        contactImageView.image = getContactImage()
        instagramPictureImageView.kf.setImage(with: getInstagramProfilePictureLink())
        twitterPictureImageView.kf.setImage(with: getTwitterProfilePictureLink())
        youtubePictureImageView.kf.setImage(with: getYouTubeProfilePictureLink())
        
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
        
        let imageData = UIImageJPEGRepresentation(getContactImage()!, 1.0)
        
        SwapUser().uploadProfilePicture(withData: imageData!, completion: {_ in 
        
            self.performSegue(withIdentifier: "showHome", sender: nil)
        
        })
        
       
    }
    @IBAction func didSelectInstagramPhoto(_ sender: Any) {
        
        let imageData = NSData(contentsOf: getInstagramProfilePictureLink()!)
        
        SwapUser().uploadProfilePicture(withData: imageData! as Data, completion: {_ in
            
            self.performSegue(withIdentifier: "showHome", sender: nil)
            
        })
    }
    @IBAction func didSelectTwitterPhoto(_ sender: Any) {
        
        let imageData = NSData(contentsOf: getTwitterProfilePictureLink()!)
        
        SwapUser().uploadProfilePicture(withData: imageData! as Data, completion: {_ in
            
            self.performSegue(withIdentifier: "showHome", sender: nil)
            
        })

    }
    @IBAction func didSelectYouTubePhoto(_ sender: Any) {
        
        let imageData = NSData(contentsOf: getYouTubeProfilePictureLink()!)
        
        SwapUser().uploadProfilePicture(withData: imageData! as Data, completion: {_ in
            
            self.performSegue(withIdentifier: "showHome", sender: nil)
            
        })
    }
    

}
