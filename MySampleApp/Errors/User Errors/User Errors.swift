//
//  User Errors.swift
//  Swap
//
//  Created by Micheal S. Bingham on 12/8/16.
//
//

import Foundation

/// UserError
/// - CouldNotGetUser: Could not loader user from database
/// - WillNotShareSocialMedia: User has denied access to social media
/// - NotConnected: User does not have social media connected
/// - Unknown: Unknown Error
enum UserError: Error {
    
    case CouldNotGetUser
    case WillNotShareSocialMedia
    case NotConnected
    case Unknown
    case CannotFollowSelf
    
}
