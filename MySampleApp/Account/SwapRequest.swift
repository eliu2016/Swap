//
//  SwapRequest.swift
//  Swap
//
//  Created by Micheal S. Bingham on 1/14/17.
//
//
import Foundation
import UIKit
import AWSDynamoDB

class SwapRequest: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _sender: String?
    var _requested: String?
    var _sender_confirmed_acceptance: NSNumber?
    var _sent_at: NSNumber?
    var _status: NSNumber?
    var _requested_user_has_responded_to_request: NSNumber?
    
    var user: Users?
    
    class func dynamoDBTableName() -> String {
        
        return "swap-mobilehub-1081613436-SwapRequest"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_sender"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_requested"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_sender" : "sender",
            "_requested" : "requested",
            "_sender_confirmed_acceptance" : "sender_confirmed_acceptance",
            "_sent_at" : "sent_at",
            "_status" : "status",
            "_requested_user_has_responded_to_request" :"requested_user_has_responded_to_request",
            
        ]
    }
}
