//
//  Custom Operators.swift
//  Swap
//
//  Created by Micheal S. Bingham on 11/28/16.
//
//

import Foundation

// declaring custom operator
infix operator ~ { associativity left precedence 160 }

/// Operator that tests if two phone numbers are the same. Handles the case that one phone number has country code and one does not.
///
/// - Parameters:
///   - left: First string (phone number) to compare
///   - right: Second string (phone number) to compare
/// - Returns: True if one string is a string subset of the other, false if not
func ~(left: String?, right: String?) -> Bool {
    
    guard  let Left = left, let Right = right else{
        
        // ensures the strings have a value
        return false
    }
    
    return (Left.digits.contains(Right.digits) || Right.digits.contains(Left.digits))
}


// MARK: - Extension to convert phone number strings to numbers only: +1 (555)-555-5555  = 15555555555
extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
}

// Mark: - Extension to trim whitespace
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    
    func isAValidUsername() -> Bool {
        let RegEx = "\\A\\w{1,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    /// Converts a string to a Date if the date is in the form: Wed Aug 29 17:12:58 +0000 2012
       ///
    /// - Returns: The converted Date
        func toDate() -> Date {
        
            
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MM dd HH:mm:ss Z yyyy"
        
        
        
        
        
        let date = dateFormatter.date(from: self)
            
        return date!
        }
}



