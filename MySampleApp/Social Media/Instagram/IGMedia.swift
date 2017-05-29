//
//  IGMedia.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/2/17.
//
//

import Foundation
import SwiftyJSON

class IGMedia {
    
    var id: String = ""
    var isLiked: Bool = false
    var content_url: URL?
    var type: IGMediaType = .photo // Assume a photo by default 
    var date_created: Date = Date()
    var likes: NSNumber = 0
    var caption: String = ""
    var full_name_of_creator: String = ""
    var username_of_creator: String = ""
    var id_of_creator: String = ""
    var thumbnail_url: URL?
    var creator_profile_picture_URL: URL?
    
    
    // Read JSON response to create media object
    init(media: JSON) {
        
        let user_has_liked  = media["user_has_liked"].bool ?? false
        let username = media["user"]["username"].string ?? ""
        let full_name = media["user"]["full_name"].string ?? ""
        let profile_picture = media["user"]["profile_picture"].string ?? ""
        let user_id = media["user"]["id"].string ?? ""
        let Likes = media["likes"]["count"].number ?? 0
        let time_created = media["caption"]["created_time"].string ?? "0"
        let media_type = media["type"].string ?? ""
        let ID = media["id"].string ?? ""
        let contentURL = media["images"]["standard_resolution"]["url"].string ?? ""
        let thumbnailURL = media["images"]["thumbnail"]["url"].string ?? ""
        let text = media["caption"]["text"].string ?? ""
        
        self.id = ID
        self.isLiked = user_has_liked
        self.content_url = URL(string: contentURL)
        
        if media_type == "image"{
            self.type = .photo
        } else{
            self.type = .video
        }
        
    
        self.date_created = Date(timeIntervalSince1970: Double(time_created)!)
        
        self.likes = Likes
        self.caption = text
        self.full_name_of_creator = full_name
        self.username_of_creator = username
        self.id_of_creator = user_id
        self.thumbnail_url = URL(string: thumbnailURL)
        self.creator_profile_picture_URL = URL(string: profile_picture)
       
    }
    
    func like(completion: (_ error: Error?) -> Void = {_ in return})  {
        
    }
    
     func unlike(completion: (_ error: Error?) -> Void = {_ in return})  {
        
    }
    
    func comment(withText: String?, completion: (_ error: Error?) -> Void = {_ in return})  {
        
    }
    
    func getComments(completion: (_ error: Error?, _ comments: [IGComment]?) -> Void = {_ in return})  {
        
        
    }
  
}

enum IGMediaType{
    
    case video
    case photo
}

