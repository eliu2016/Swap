//
//  YoutubeView.swift
//  Swap
//
//  Created by David Slakter on 4/27/17.
//
//

import Foundation


var YouTubeUserID: String? = nil

class YoutubeView: UIViewController {
    
    var youtubeVideos: [URL] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        let user = YouTubeUser(id:  YouTubeUserID ?? "")
        
        
        
    }
    
}
