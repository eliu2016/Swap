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

    let loadingView = ShowLoadingOverlay().showLoadingSymbol()
    
    override func viewDidLoad() {
        
        self.view.addSubview(loadingView)
        
        swapLink.text = "Swapapp.co/\(getUsernameOfSignedInUser())"
        
        let shareVC = UIActivityViewController(activityItems: [swapLink.text!], applicationActivities: nil)
        present(shareVC, animated: true, completion: {
            
            self.loadingView.isHidden = true
            
        })
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        let shareVC = UIActivityViewController(activityItems: [swapLink.text!], applicationActivities: nil)
        present(shareVC, animated: true, completion: {
            
            self.loadingView.isHidden = true
        
        })
        
    }
    
}
