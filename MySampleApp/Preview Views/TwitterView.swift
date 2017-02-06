//
//  twitterView.swift
//  Swap
//
//  Created by David Slakter on 1/31/17.
//
//

import Foundation
import TwitterKit

class TwitterView: TWTRTimelineViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "realDonaldTrump", apiClient: client)
        
        
        TWTRTweetView.appearance().backgroundColor = UIColor(colorLiteralRed: 0.110, green: 0.161, blue: 0.212, alpha: 1.00)
        TWTRTweetView.appearance().primaryTextColor = UIColor.white
        self.showTweetActions = true
    }
}
