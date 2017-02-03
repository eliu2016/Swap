//
//  IGMedia.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/2/17.
//
//

import Foundation

class IGMedia {
    
    var id: String = ""
    var isLiked: Bool = false
    var content_url: URL
    var type: IGMediaType = .photo // Assume a photo by default 
    var date_created: Date = Date()
    var likes: NSNumber = 0
    var caption: String = ""
    var full_name_of_creator: String = ""
    var username_of_creator: String = ""
    var id_of_creator: String = ""
    var thumbnail_url: URL
    
    
    // Read JSON response to create media object
    init(mediaJSON: JSON) {
        
        
    }
    
    func like(completion: (_ error: Error?) -> Void = {_ in return})  {
        
    }
    
     func unlike(completion: (_ error: Error?) -> Void = {_ in return})  {
        
    }
    
    func comment(withText: String?, completion: (_ error: Error?) -> Void = {_ in return})  {
        
    }
    
    func getComments(completion: (_ error: Error?, _ comments: [IGComment]?) -> Void = {_ in return}) -> [IGComment]?  {
        
        
    }
    
    
 
}

enum IGMediaType{
    
    case video
    case photo
}

