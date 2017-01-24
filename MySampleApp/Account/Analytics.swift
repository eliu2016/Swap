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
    
    ///-todo: For some reason, in analytics, the custom attributes are not being recorded. Fix.
    class func didSwap(byMethod: SwapMethod, isPrivate: Bool = false, didShareSpotify: Bool = false, didSharePhone: Bool = false, didShareEmail: Bool = false, didShareInstagram: Bool = false, didShareSnapchat: Bool = false, didShareTwitter: Bool = false, didShareYouTube: Bool = false, didShareSoundCloud: Bool = false, didSharePinterest: Bool = false){
        
        var method = ""
        if byMethod == .username{
            method = "Username"
        } else if byMethod == .swapcode{
            method = "Swap Code"
        }
        
        if isPrivate{
            
            Answers.logCustomEvent(withName: "Swap", customAttributes: [
                
                "Method" : method,
                "Private Swap Request": true as NSNumber
                ])
            
        }  else{
        
        Answers.logCustomEvent(withName: "Swap", customAttributes: [
            
            "Method" : method,
            "Spotify": didShareSpotify as NSNumber,
            "Phone Number": didSharePhone as NSNumber,
            "Email": didShareEmail as NSNumber,
            "Instagram": didShareInstagram as NSNumber,
            "Snapchat" : didShareSnapchat as NSNumber,
            "Twitter" : didShareTwitter as NSNumber,
            "YouTube": didShareYouTube as NSNumber,
            "SoundCloud": didShareSoundCloud as NSNumber,
            "Pinterest": didSharePinterest as NSNumber
            

            ])
        
        
        }
    }
    
   
    
}

enum SwapMethod {
    case username
    case swapcode
}
