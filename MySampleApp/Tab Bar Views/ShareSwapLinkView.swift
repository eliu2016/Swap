//
//  ShareSwapLinkView.swift
//  Swap
//
//  Created by David Slakter on 1/26/17.
//
//

import Foundation

class ShareSwapLinkView: UIViewController{
    
    @IBOutlet var swapLink: UILabel!
    
    override func viewDidLoad() {
        
        swapLink.text = "Swapapp.co/\(getUsernameOfSignedInUser())"
        
        let shareVC = UIActivityViewController(activityItems: [swapLink.text!], applicationActivities: nil)
        present(shareVC, animated: true, completion: nil)
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
