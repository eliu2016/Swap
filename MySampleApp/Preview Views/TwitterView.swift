//
//  twitterView.swift
//  Swap
//
//  Created by David Slakter & Micheal S. Bingham  on 1/31/17.
//
//

import Foundation
import TwitterKit

var twitterUserID: String? = nil

class TwitterView: TWTRTimelineViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //declare UI variables
        let overlayImage = UIImageView()
        overlayImage.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        overlayImage.backgroundColor = UIColor.white
        self.view.addSubview(overlayImage)
        overlayImage.isHidden = true
        
        let noTwitterLabel = UILabel(frame: CGRect(x: self.view.center.x-65, y: self.view.center.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        noTwitterLabel.text = "No Twitter Feed"
        noTwitterLabel.textColor = .black
        noTwitterLabel.textAlignment = NSTextAlignment.center
        noTwitterLabel.font = UIFont(name: "Avenir-Next", size: 20)
        noTwitterLabel.sizeToFit()
        self.view.addSubview(noTwitterLabel)
        
        noTwitterLabel.isHidden = true
        
      
        let client = TWTRAPIClient()
       client.loadUser(withID: twitterUserID ?? "") { (user, error) in
        
    
        guard error == nil else{
            print("Error... Could not obtain Twitter. Invalid twitter ID or user does not have twitter connected")
            
            overlayImage.isHidden = false
            noTwitterLabel.isHidden = false
            
            
            return
        }
        
        
        guard !(user?.isProtected ?? true) else {
            
            print("Cannot view Tweets of a protected/private user. Twitter is private")
            
            overlayImage.isHidden = false
            noTwitterLabel.isHidden = false
            
            return
        }
        
        self.dataSource = TWTRUserTimelineDataSource(screenName: nil, userID: twitterUserID, apiClient: client, maxTweetsPerRequest: 500, includeReplies: true, includeRetweets: true)
        TWTRTweetView.appearance().backgroundColor = UIColor(colorLiteralRed: 0.110, green: 0.161, blue: 0.212, alpha: 1.00)
        TWTRTweetView.appearance().primaryTextColor = UIColor.white
        self.showTweetActions = true
        
        }
        
    }
}
