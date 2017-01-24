//
//  PrivacyPolicyView.swift
//  Swap
//
//  Created by David Slakter on 1/15/17.
//
//

import Foundation

class PrivacyPolicy: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
        
        let privacyPolicyURL = NSURL(string: "http://www.getswap.net/private-policy")
        let webRequest = NSURLRequest(url: privacyPolicyURL! as URL)
        self.webView.loadRequest(webRequest as URLRequest)
            
        }
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}
