//
//  ShareSwapLinkView.swift
//  Swap
//
//  Created by David Slakter on 1/26/17.
//
//

import Foundation
import Answers

class ShareSwapLinkView: UIViewController{
    
    @IBOutlet var swapLink: UILabel!

    var loadingView: UIImageView? = nil
    
    override func viewDidLoad() {
        
        loadingView = ShowLoadingOverlay().showLoadingSymbol(view: self.view)
        
        self.view.addSubview(loadingView!)
        
        swapLink.text = "getswap.me/\(getUsernameOfSignedInUser())"
        
        let shareVC = UIActivityViewController(activityItems: ["Swap with me! " + swapLink.text!], applicationActivities: nil)
        present(shareVC, animated: true, completion: {
            
            self.loadingView?.isHidden = true
            
        })
    }

    @IBAction func copyLink(_ sender: Any) {
        
        UIPasteboard.general.string = swapLink.text
        
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        
        self.loadingView?.isHidden = false
        
        let shareVC = UIActivityViewController(activityItems: [swapLink.text!], applicationActivities: nil)
        present(shareVC, animated: true, completion: {
            
            self.loadingView?.isHidden = true
            
            Answers.logInvite(withMethod: "Swap Link",
                                        customAttributes: nil)

        
        })
        
    }
    
}
