//
//  IGUser.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/2/17.
//
//

import Foundation

class IGUser {

    var id: String = ""
    
    
    func getMedia(completion: (_ updatedMedia: IGMedia?) -> Void) -> IGMedia? {
        
        // Get Cached JSON Object containing response for IGMedias and return IGMedia Objects based on it
        
        // Attempt to download new media objects and add it to cache. Return nil if nothing is new
        
        
        // If there's new Data
        NotificationCenter.default.post(Notification.Name.updatedInstagramMedia)
    }
}


extension Notification.Name{
    
    static let  updatedInstagramMedia = Notification.Name("updatedInstagramMedia")
}
