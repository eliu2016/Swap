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
      
        let client = TWTRAPIClient()
       
        self.dataSource = TWTRUserTimelineDataSource(screenName: nil, userID: twitterUserID, apiClient: client, maxTweetsPerRequest: 500, includeReplies: true, includeRetweets: true)
        TWTRTweetView.appearance().backgroundColor = UIColor(colorLiteralRed: 0.110, green: 0.161, blue: 0.212, alpha: 1.00)
        TWTRTweetView.appearance().primaryTextColor = UIColor.white
        self.showTweetActions = true
    }
}
