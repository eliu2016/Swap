//
//  Analytics.swift
//  Swap
//
//  Created by Micheal Bingham  on 1/23/17.
//
//
import Foundation
import Answers
import Crashlytics

class Analytics {
    
    class func didSignUp()  {
        
        Answers.logSignUp(withMethod: "Swap",
                          success: true,
                          customAttributes: nil)
        
        
    }
    
    class func didSignIn(){
        
        Answers.logLogin(withMethod: "Swap",
                         success: true,
                         customAttributes: nil)
    }
    
    class func didSignOut(){
        
        Answers.logCustomEvent(withName: "Sign Out",
                               customAttributes: nil)
    }
    
    class func didSwapByScanningSwapCode(){
        
        Answers.logCustomEvent(withName: "Scanned Swap Code",
                               customAttributes: nil)
    }
    
    class func didSwapByButton(){
        
        Answers.logCustomEvent(withName: "Swapped via Swap Button",
                               customAttributes: nil)
    }
    
}
