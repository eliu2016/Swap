//
//  IGComment.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/2/17.
//
//

import Foundation
import SwiftyJSON
class IGComment {
    
    
    
    var date_created: Date = Date()
    var text: String =  ""
    var from_username: String = ""
    var from_profile_picture: URL?
    var from_id: String = ""
    var from_full_name: String = ""
    
    // Initialize Comment Object With JSOn
    init(commentJSON: JSON) {
        
        
    }
    
    
}
