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
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Gathers profile pictures from social medias
        
        contactImageView.image = getContactImage()
        instagramPictureImageView.kf.setImage(with: getInstagramProfilePictureLink())
        twitterPictureImageView.kf.setImage(with: getTwitterProfilePictureLink())
        youtubePictureImageView.kf.setImage(with: getYouTubeProfilePictureLink())
        
      
    
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

}
