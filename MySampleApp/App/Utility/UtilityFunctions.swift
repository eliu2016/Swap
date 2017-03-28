//
//  UtilityFunctions.swift
//  MySampleApp
//
//  Use this file to add Utility Functions shared by the App
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



func prettyPrintJson(_ object: AnyObject?) -> String {
    var prettyResult: String = ""
    if object == nil {
        return ""
    } else if let resultArray = object as? [AnyObject] {
        var entries: String = ""
        for index in 0..<resultArray.count {
            if (index == 0) {
                entries = "\(resultArray[index])"
            } else {
                entries = "\(entries), \(prettyPrintJson(resultArray[index]))"
            }
        }
        prettyResult = "[\(entries)]"
    } else if object is NSDictionary  {
        let objectAsDictionary: [String: AnyObject] = object as! [String: AnyObject]
        prettyResult = "{"
        var entries: String = ""
        for (key,_) in objectAsDictionary {
            entries = "\"\(entries), \"\(key)\":\(prettyPrintJson(objectAsDictionary[key]))"
        }
        prettyResult = "{\(entries)}"
        return prettyResult
    } else if let objectAsNumber = object as? NSNumber {
        prettyResult = "\(objectAsNumber.stringValue)"
    } else if let objectAsString = object as? NSString {
        prettyResult = "\"\(objectAsString)\""
    }
    return prettyResult
}



extension Notification.Name {
    
    //reload notifications
    static let reloadProfile = Notification.Name("reloadProfile")
    static let reloadSearchedUserProfile = Notification.Name("reloadSearchedUserProfile")
    static let reloadNotifications = Notification.Name("reloadNotifications")
    
    //page control notifications
    static let updatePageControl = Notification.Name("updatePageControl")
  

}
