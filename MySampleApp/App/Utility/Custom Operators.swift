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
    
    func validate(completion: @escaping (_ isAValidUsername: Bool, _ errorMessage: String?) -> Void)  {
        
        if self.characters.count < 1{
            let message = "Usernames must be at least one character."
            completion(false, message)
        }
        
        else if self.characters.count > 18{
            let message = "Usernames must be less than 18 characters."
              completion(false, message)
        }
        
        else if !self.isAValidUsername(){
            
            let message = "Usernames cannot contain special characters."
              completion(false, message)
        }
        
        else {
        
        
        pool.getUser(self.lowercased()).confirmSignUp("0").continue({  (task)  in
            DispatchQueue.main.async {
                
                if let error = task.error as? NSError{
                    
                    
                    if error.debugDescription.contains("Invalid code provided"){
                        // User Exists
                        print("user exists")
                        let message = "Username is taken, try another."
                          completion(false, message)
                        
                    } else{
                        
                        // User Does Not Exist
                         completion(true, nil)
                    }
                    
                }
                
                
            }
            
            
        })
            
        }
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

extension NSNumber{
    
    func timeAgo() -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        return timeAgoSinceDate(date: date as NSDate, numericDates: false)
    }
    
}



extension Date{
    
    func timeAgo() -> String {
        
        
        return timeAgoSinceDate(date: self as NSDate, numericDates: false)
    }
}




func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}



