//
//  Contacts.swift
//  Swap
//
//  Created by Dr. Stephen, Ph.D on 11/28/16.
//
//
import Foundation
import Contacts


@available(iOS 9.0, *)

/// Function that tried to find a contact in addressbook with specified phone number in background. Saves phonenumber, name, website, contact photo, and company in User Defaults. Country code can be included or omitted. Doesn't make a difference.
///
/// - Parameter withPhonenumber: Phonenumber of the user
func getContact(withPhonenumber: String)  {
    
    DispatchQueue.global(qos: .background).async {
        
        var contactFound: CNContact?
        var contactIsFound: Bool = false  {
            
            didSet {
                
                if contactIsFound{
                    // contact is found
                    // Run code here after the contact is found
                    
                    print("Contact is found!")
                    // Get the information of the contact
                    let firstname = contactFound?.givenName
                    let middlename = contactFound?.middleName
                    let lastname = contactFound?.familyName
                    let website = contactFound?.urlAddresses.first?.value as String?
                    let company = contactFound?.organizationName
                    let imageData = contactFound?.imageData
                    
                    
                    // Save it
                    saveFirstname(name: firstname)
                    saveMiddlename(name: middlename)
                    saveLastname(name: lastname)
                    saveWebsite(name: website)
                    saveCompany(name: company)
                    saveContactImage(imageData: imageData)
                    
                    
                    
                    
                    
                }
                
            }
        }
        
        // Background Thread
        let contactStore = CNContactStore()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStore.defaultContainerIdentifier())
        
        var contacts: [CNContact]! = []
        
        
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataKey,
            CNContactOrganizationNameKey,
            CNContactUrlAddressesKey] as [Any]
        
        
        do {
            // Adds all contacts to contracts array
            print("Trying to get contacts")
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])// [CNContact]
        }catch {
            
            print("cannot get contacts for some reason")
            // failed
            
        }
        
        // iterates through all contacts
        for contact in contacts{
            
            print("Looping through contacts")
            // If a contact has more than one phone number
            if contact.phoneNumbers.count > 1 {
                
                print("more than one phone number")
                // Loop through all phone numbers
                
                for number in contact.phoneNumbers {
                    
                    print("looping")
                    if number.value.stringValue ~ withPhonenumber{
                        // phone number is similar to withPhoneNumber
                        print("contact is found")
                        contactFound = contact
                        contactIsFound = true
                        
                        
                    }
                }
                
            }  else{
                // There is only ONE Phone number
                
                print("only one phone number")
                // Tests that phone number
                
                let num = contact.phoneNumbers.first?.value.stringValue
                
                print("The number is ...\(num)")
                
                
                if num ~ withPhonenumber {
                    //Phone number is found
                    
                    print("contact is found")
                    contactFound = contact
                    contactIsFound = true
                    
                    
                }
                else{
                    print("Contact is not found yet")
                }
            }
            
        }
        
        
    }
    
    
    
}

