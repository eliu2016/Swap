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
    
    
    
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.isHidden = true
      
       MakeBlurViewCircular(blurView: BlurView1)
       MakeBlurViewCircular(blurView: BlurView2)
       MakeBlurViewCircular(blurView: BlurView3)
        
        usernameLabel.text = searchedUser
        
        SwapUser(username: searchedUser).getInformation { (error, user) in
       
            DispatchQueue.main.async {
            
            self.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
            circularImage(photoImageView: self.profilePicture)
            
            self.fullName.text = ((user?._firstname)! + " " + (user?._lastname)!).uppercased()
                
            }
        }

    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
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
