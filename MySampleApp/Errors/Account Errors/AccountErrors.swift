//
//  AccountErrors.swft
//  Swap
//
//  Created by Micheal S .Bingham on 11/19/16.
//  Copyright © 2016 Swap Inc. All rights reserved.
//

import Foundation

/// Enum Representing the type of errors that can happen during the Account Sign Up Process
/// - Author: Micheal S. Bingham
///
/// - UsernameTaken: Username already exists
/// - PasswordTooShort: Password must be at least 6 characters
/// - InvalidEmail: User did not enter a valid email address
/// - InvalidPhonenumber: User did not enter a valud phone number
/// - EmptyFields: One or more fields were not entered while the user was signing up
/// - InvalidUsername: Entered username is not a valid format. Maybe user entered spaces
enum SignUpError: Error {
    
    case UsernameTaken
    case PasswordTooShort
    case InvalidEmail
    case InvalidPhonenumber
    case EmptyFields
    case InvalidUsername
    case UnknownSignUpError
    
    
}
