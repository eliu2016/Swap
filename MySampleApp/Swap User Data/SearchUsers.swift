//
//  SearchUsers.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/28/16.
//
//

import Foundation
import AWSCognitoIdentityProvider



/// Function to search for users by username
///
/// - Parameters:
///   - withUsername: Pass a partial username string to search for
///   - completion: Returns an error and an array of SwapUser objects. Ensure that you unwrap the SwapUser array before iterating, also, be certain that there is no error (error == nil) before unwraping users array because it will be 'nil' if there is an error. Each SwapUser object contains the username and profile link url. See SwapUser class for more information. See exmaple in the function body.


func searchUsers(withUsername: String, completion: @escaping (_ error: Error?, _ users: [SwapUser]? ) -> Void
    )  {
    
    
    
    
    /*:
     
     - Example:
     
     searchUsers(withUsername: "mic", completion:{ (error, users) in
     
     if error != nil{
     
     // There is an error. No not attempt to unwrap users array
     
     }
     
     else {
     
     // There is no error. Now you can unwrap users array
     
     
     for user in users!{
     
     
     print("the user is .. \(user.username) and the verification status is ... \(user.isVerified) and the profile picture is ... \(user.profilePictureURL)")
     }
     
     
     
     }
     
     })
     
     */
    
    
    
    
    
    
    
    let getUsersRequest = AWSCognitoIdentityProviderListUsersRequest()
    getUsersRequest?.userPoolId = AWSCognitoUserPoolId
    getUsersRequest?.filter = "username ^= \"\(withUsername.lowercased())\""
    getUsersRequest?.attributesToGet = ["profile", "picture"]
    getUsersRequest?.limit = 10
    
    
    idManager.listUsers(getUsersRequest!, completionHandler: { (response, error) in
        
        if error != nil{
            print("Could not search with error ... \(error)")
            
            completion(error, nil)
            
        }
            
        else{
            
            if response != nil{
                
                
                if let users = response?.users{
                    
                    
                    
                    completion(nil, convertCognitoUsersArrayToSwapUsersArray(users: users))
                    
                    
                } else{
                    
                    completion(UserError.Unknown, nil)
                    
                    
                }
                
                
                
                
                
            }
                
            else{
                
                completion(UserError.Unknown, nil)
            }
            
            
            
        }
        
    })
    
    
    
}






func convertCognitoUserToSwapUser(user: AWSCognitoIdentityProviderUserType ) -> SwapUser {
    
    
    var isVerified: Bool = false
    var link: URL = URL(string: defaultImage)!
    let Username = user.username!
    var swap_user = SwapUser(username: Username)
    let attributes = user.attributes!
    
    
    
    for attribute in attributes{
        
        if attribute.name == "profile" && attribute.value == "IS_VERIFIED"{
            // USER IS VERIFIED
            isVerified = true
        }
        
         if attribute.name == "picture"{
            
            link = URL(string: attribute.value!)!
        }
        
       
        
    }
    
    swap_user.isVerified =  isVerified
    swap_user.profilePictureURL = link
    
    return swap_user
    
}

func convertCognitoUsersArrayToSwapUsersArray(users: [AWSCognitoIdentityProviderUserType]) -> [SwapUser] {
    
    var SwapUsers: [SwapUser] = []
    
    for user in users{
        
       if user.userStatus.rawValue == 2{
        SwapUsers.append(convertCognitoUserToSwapUser(user: user))
        }
        
    }
    
    return SwapUsers
}
