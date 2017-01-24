//
//  Compilation.swift
//  Swap
//
//  Created by Micheal S. Bingham on 1/15/17.
//
//
import Foundation
import RealmSwift

class Compilation: Object {
    
    dynamic var id: String = ""
    dynamic var profilePicture: String = ""
    dynamic var name: String = ""
    dynamic var updatedAt: Date?
    dynamic var hasBeenViewed: Bool = false
    dynamic var isVerified: Bool = false
    var Tweets = List<Tweet>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
