//
//  IGUser.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/2/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class IGUser {

    var id: String = ""
    
    init(id: String) {
        
        self.id = id
    }
    
    
    func getMedia(completion: @escaping (_ medias: [IGMedia]?) -> Void) {
        
        
        Alamofire.request("https://api.instagram.com/v1/users/\(self.id)/media/recent/", method: .get, parameters: ["access_token": instagram_oauth2.accessToken ?? ""]).responseJSON { (response) in
            
            if let Data = response.data{
                
                let mediaObjects = JSON(data: Data)
                let medias: [IGMedia] = mediaObjects.toIGMedias()
                
                completion(medias)
               
                
            }
        }
      
    }
}


extension Notification.Name{
    
    static let  updatedInstagramMedia = Notification.Name("updatedInstagramMedia")
}

extension JSON{
    
    func toIGMedias() -> [IGMedia] {
        
        var medias: [IGMedia] = []
        let jsonResponse = self
        
        guard jsonResponse["data"].array != nil else {
            
            return []
        }
        
        let arrayOfJSONs = jsonResponse["data"].array!
        
        for json in arrayOfJSONs{
            
            
            let media = IGMedia(media: json)
            medias.append(media)
        }
        
        return medias
    }
}
