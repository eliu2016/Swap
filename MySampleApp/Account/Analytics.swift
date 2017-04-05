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
    class func didSwap(byMethod: SwapMethod, isPrivate: Bool = false, didShareSpotify: Bool = false, didSharePhone: Bool = false, didShareEmail: Bool = false, didShareInstagram: Bool = false, didShareReddit: Bool = false, didShareTwitter: Bool = false, didShareYouTube: Bool = false, didShareSoundCloud: Bool = false, didSharePinterest: Bool = false, didShareGitHub: Bool = false, didShareVimeo: Bool = false){
        
        var method = ""
        if byMethod == .username{
            method = "Username"
        } else if byMethod == .scan{
            method = "Scan"
        }
        else if byMethod == .upload{
            method = "Upload"
        }
        
        if isPrivate{
            
            Answers.logCustomEvent(withName: "Swap", customAttributes: [
                
                "Method" : method,
                "Private Swap Request": true.toString()
                ])
            
        }  else{
        
        Answers.logCustomEvent(withName: "Swap", customAttributes: [
            
            "Method" : method,
            "Spotify": didShareSpotify.toString(),
            "Phone Number": didSharePhone.toString(),
            "Email": didShareEmail.toString(),
            "Instagram": didShareInstagram.toString(),
            "Reddit" : didShareReddit.toString(),
            "Twitter" : didShareTwitter.toString(),
            "YouTube": didShareYouTube.toString(),
            "SoundCloud": didShareSoundCloud.toString(),
            "Pinterest": didSharePinterest.toString(),
            "GitHub": didShareGitHub.toString(),
            "Vimeo": didShareVimeo.toString(),
            "Private Swap Request" : false.toString()
            

            ])
        
        
        }
    }
    
   
    
}

enum SwapMethod {
    case username
    case scan
    case upload
}


extension Bool{
    
    func toString() -> String {
        
        if self{
            return "Shared"
        } else{
            return "Not Shared"
        }
    }
}
