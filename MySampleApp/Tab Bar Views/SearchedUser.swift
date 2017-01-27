//
//  SearchedUser.swift
//  Swap
//
//  Created by David Slakter on 1/27/17.
//
//

import Foundation

class SearchedUser: UIViewController {
    
    @IBOutlet var BlurView1: UIVisualEffectView!
    @IBOutlet var BlurView2: UIVisualEffectView!
    @IBOutlet var BlurView3: UIVisualEffectView!
    @IBOutlet var username: UILabel!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    
    override func viewDidLoad() {
      
       MakeBlurViewCircular(blurView: BlurView1)
       MakeBlurViewCircular(blurView: BlurView2)
       MakeBlurViewCircular(blurView: BlurView3)
    
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
