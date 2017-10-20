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
    
    override func viewWillAppear(_ animated: Bool) {
        
        //configure nav bar
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ShareIcon"), style: .plain, target: self, action: #selector(didTapShare))
        shareButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = shareButton
        
    }

    @IBAction func copyLink(_ sender: Any) {
        
        UIPasteboard.general.string = swapLink.text
        
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapShare() {
        
        self.loadingView?.isHidden = false
        
        let shareVC = UIActivityViewController(activityItems: [swapLink.text!], applicationActivities: nil)
        present(shareVC, animated: true, completion: {
            
            self.loadingView?.isHidden = true
            
//           Answers.logInvite(withMethod: "Swap Link", customAttributes: nil)
        
        })
        
    }
    
}
