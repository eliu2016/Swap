//
//  SwapHistory.swift
//  Swap
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.8
//
import Foundation
import UIKit
import AWSDynamoDB

class SwapHistory: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _swap: String?
    var _swapped: String?
    var _didShareBirthday: NSNumber?
    var _didShareEmail: NSNumber?
    var _didShareInstagram: NSNumber?
    var _didSharePhonenumber: NSNumber?
    var _didSharePinterest: NSNumber?
    var _didShareReddit: NSNumber?
    var _didShareSoundCloud: NSNumber?
    var _didShareSpotify: NSNumber?
    var _didShareTwitter: NSNumber?
    var _didShareVine: NSNumber?
    var _didShareYouTube: NSNumber?
    var _didShareGitHub: NSNumber?
    var _didShareVimeo: NSNumber?
    var _location: Set<NSNumber>?
    var _method: String?
    var _time: NSNumber?
    var _didGiveSwapPointsFromSwap: NSNumber?
    var profileImageURL: URL?
    var firstname: String?
    var lastname: String?
    var user: Users?
    
    class func dynamoDBTableName() -> String {
        
        return "swap-mobilehub-1081613436-Swap_History"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_swap"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_swapped"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_swap" : "swap",
            "_swapped" : "swapped",
            "_didShareBirthday" : "didShareBirthday",
            "_didShareEmail" : "didShareEmail",
            "_didShareInstagram" : "didShareInstagram",
            "_didSharePhonenumber" : "didSharePhonenumber",
            "_didSharePinterest" : "didSharePinterest",
            "_didShareReddit" : "didShareReddit",
            "_didShareSoundCloud" : "didShareSoundCloud",
            "_didShareSpotify" : "didShareSpotify",
            "_didShareTwitter" : "didShareTwitter",
            "_didShareVine" : "didShareVine",
            "_didShareYouTube" : "didShareYouTube",
            "_didShareGitHub" : "didShareGitHub",
            "_didShareVimeo" : "didShareVimeo",
            "_location" : "location",
            "_method" : "method",
            "_time" : "time",
            "_didGiveSwapPointsFromSwap": "didGiveSwapPointsFromSwap"
        ]
    }
}
