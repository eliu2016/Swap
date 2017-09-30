//
//  YouTubeUser.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/7/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON
class YouTubeUser {
    
    
    var id: String = ""
    init(id: String) {
        self.id = id
    }
     func getMedia(completion: @escaping ([YouTubeMedia]?) -> Void) {
        
        let url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBAD9wkbpY5e79RopR9Guz8DQI674zqDN8&channelId=\(self.id)&part=snippet,id&order=date&maxResults=50"
        
        Alamofire.request(url, method: .get, parameters: nil,  headers: nil).responseJSON { (response) in
            
            if let data = response.data{
                
                let mediaObjects = JSON(data: data)
                let medias: [YouTubeMedia] = mediaObjects.toYouTubeMedias()
                
                completion(medias)
                
            }
            
        }
        
    }
    
}
