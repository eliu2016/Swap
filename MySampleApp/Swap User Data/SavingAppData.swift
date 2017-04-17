//
//  SavingDataInApp.swift
//  Swap
//
//  Created by Micheal S. Bingham on 11/27/16.
//
// Use this to save any type of data in the app –– never pass information through view controllers
import Foundation



/// Call this function to save the user's entered username in a field. This should be used whenever you want to save the usrename entered in order to pass it to a new view controller. For example, call saveUsername to save the username while the user is signing up and then getSavedUsername() to pass it to the sign in view controller text field so the user will not have to enter it again.
///
/// - Parameter username: Username to save.
func saveUsername(username: String?) {
    UserDefaults.standard.set((username ?? "").lowercased(), forKey: "username")
    UserDefaults.standard.synchronize()
}

/// Call this function to get the saved username when saveUsername(:_) was called.
///
/// - Returns: Username string optional.
func getSavedUsername() -> String? {
    
    return UserDefaults.standard.string(forKey: "username")
}

/// Save the password passed in the fuction to NSUserDefaults.
///
/// - Parameter password: Password to save.
func savePassword(password: String?)  {
    
    UserDefaults.standard.set(password, forKey: "password")
    UserDefaults.standard.synchronize()
}

/// Return the password saved.
///
/// - Returns: Password string optional.
func getSavedPassword() -> String? {
    return UserDefaults.standard.string(forKey: "password")
}

/// Saves the firstname in user defaults.
func saveFirstname(name: String?)  {
    
    UserDefaults.standard.set(name, forKey: "firstname")
    UserDefaults.standard.synchronize()
}


/// Gets the saved firstname from user defaults.
func getSavedFirstname() -> String? {
    
    return UserDefaults.standard.string(forKey: "firstname")
    
}

/// Saves the middlename in user defaults.
func saveMiddlename(name: String?)  {
    
    UserDefaults.standard.set(name, forKey: "middlename")
    UserDefaults.standard.synchronize()
}

/// Gets the saved middlename from user defaults.
func getSavedMiddlename() -> String? {
    
    return UserDefaults.standard.string(forKey: "middlename")
    
}

/// Saves the lastname in user defaults.
func saveLastname(name: String?)  {
    
    UserDefaults.standard.set(name, forKey: "lastname")
    UserDefaults.standard.synchronize()
}

/// Gets the saved lastname from user defaults.
func getSavedLastname() -> String? {
    
    return UserDefaults.standard.string(forKey: "lastname")
}

/// Saves the website in user defaults.
func saveWebsite(name: String?)  {
    
    UserDefaults.standard.set(name, forKey: "website")
    UserDefaults.standard.synchronize()
}

/// Gets the saved website from user defaults.
func getSavedWebsite() -> String? {
    
    return UserDefaults.standard.string(forKey: "website")
}

/// Saves the company name in user defaults.
func saveCompany(name: String?)  {
    
    UserDefaults.standard.set(name, forKey: "company")
    UserDefaults.standard.synchronize()
}

/// Gets company name from user defaults
func getSavedCompany() -> String? {
    
    return UserDefaults.standard.string(forKey: "company")
    
}

/// Save the link to the instagram profile picture in Userdefaults
///
/// - Parameter withLink: String representing link to Instagram Profile Picture
func saveInstagramPhoto(withLink: String?) {
    
    if let stringToImage = withLink{
        UserDefaults.standard.set(URL(string: stringToImage), forKey: "instagramProfilePic")
        UserDefaults.standard.synchronize()
        
    }
}


/// Gets the Instagram Profile Picture URL saved in NSUserDefaults
///
/// - Returns: URL to Profile Picture; otherwise, is nil
func getInstagramProfilePictureLink() -> URL? {
    return UserDefaults.standard.url(forKey: "instagramProfilePic")
}

/// Save the link to the Twitter profile picture in Userdefaults
///
/// - Parameter withLink: String representing link to Twitter Profile Picture
func saveTwitterPhoto(withLink: String?)  {
    
    
    UserDefaults.standard.set(URL(string: withLink!), forKey: "twitterProfilePic")
    UserDefaults.standard.synchronize()
    
    
    
}


/// Gets the Twitter Profile Picture URL saved in NSUserDefaults
///
/// - Returns: URL to Profile Picture; otherwise, is nil
func getTwitterProfilePictureLink() -> URL? {
    return UserDefaults.standard.url(forKey: "twitterProfilePic")
}

/// Save the link to the YouTube profile picture in Userdefaults
///
/// - Parameter withLink: String representing link to YouTube Profile Picture
func saveYouTubeProfilePicture(withLink: String?)  {
    
    
    UserDefaults.standard.set(URL(string: withLink!), forKey: "youtubeProfilePicture")
    UserDefaults.standard.synchronize()
    
    
    
}


/// Gets the YouTube Profile Picture URL saved in NSUserDefaults
///
/// - Returns: URL to Profile Picture; otherwise, is nil
func getYouTubeProfilePictureLink() -> URL? {
    return UserDefaults.standard.url(forKey: "youtubeProfilePicture")
}


/// Saves the contact image from address book in user defaults.
func saveContactImage(imageData: Data?)  {
    
    UserDefaults.standard.set(imageData, forKey: "contactImage")
    UserDefaults.standard.synchronize()
}

/// Gets the contact image from user defaults as a UIImage
func getContactImage() -> UIImage? {
    
    let imageData = UserDefaults.standard.object(forKey: "contactImage") as? Data
    
    
    if imageData != nil {     return UIImage(data: imageData!) } else { return nil}
    
    
}

/// Saves the current UIViewController. Pass 'self' in this function in 'viewDidAppear' or 'viewWillAppear'. This will save the restoration ID of the view controller in order to instantiate that same view controller in app delegate. Call this function whenever you want the user to see this view controller again after they open the app after exiting or quiting. Set this to nil when user is on Profile View Controller. You ONLY want to save the last view controller when the user is on a sign up type screen.
///
/// - Parameter viewController: View Controller with a restorationID
func saveViewController(viewController: UIViewController?)  {
    
    if let vc = viewController{
        UserDefaults.standard.set(vc.restorationIdentifier, forKey: "lastViewController")
        UserDefaults.standard.synchronize()
    }
    else{
        UserDefaults.standard.removeObject(forKey: "lastViewController")
        UserDefaults.standard.synchronize()
    }
    
    
    
    
}


/// Use this function to get the restoration ID of the last (saved) view controller the user was on before exiting app.
///
/// - Returns: String indicating restoration ID of view controller
func getLastViewControllerID() -> String? {
    
    let lastVC = UserDefaults.standard.object(forKey: "lastViewController") as? String
    
    return lastVC
}

/// Use this function to save the email of the user in order to pass it to a different view controller
func saveEmail(email: String?) {
    
    UserDefaults.standard.set(email, forKey: "email")
    UserDefaults.standard.synchronize()
}

/// Get the saved phonenumber from User Defaults
func getSavedEmail() -> String? {
    return  UserDefaults.standard.object(forKey: "email") as? String
}

/// Use this function to save the phonenumber of the user in order to pass it to a different view controller
func savePhonenumber(phone: String?) {
    
    UserDefaults.standard.set(phone, forKey: "phonenumber")
    UserDefaults.standard.synchronize()
}

/// Get the saved email from User Defaults
func getSavedPhonenumber() -> String? {
    return  UserDefaults.standard.object(forKey: "phonenumber") as? String
}



/// Saves the Twitter Consumer Key and Secret in User Defaults in order to later authenticate it in order to make API Requests
///
/// - Parameters:
///   - withToken: The Token Key of the Twitter Account
///   - andSecret: The Secret of the Twitter Account
/// - Todo: Make sure that this is stored in Keychain Rather than User Defaults
func saveTwitterAccount(withToken: String, andSecret: String)  {
    
    UserDefaults.standard.set(withToken, forKey: "TwitterToken")
    UserDefaults.standard.set(andSecret, forKey: "TwitterSecret")
    UserDefaults.standard.synchronize()
}


func getTwitterToken() -> String? {
    
    return UserDefaults.standard.string(forKey: "TwitterToken")
    
}

func getTwitterSecret() -> String? {
    
    return UserDefaults.standard.string(forKey: "TwitterSecret")
    
}


func saveVine(username: String, andPassword: String)  {
    
    UserDefaults.standard.set(username, forKey: "VineUsername")
    UserDefaults.standard.set(andPassword, forKey: "VinePassword")
    UserDefaults.standard.synchronize()
}

func getVineUsername() -> String? {
    
    return UserDefaults.standard.string(forKey: "VineUsername")
    
}

func getVinePassword() -> String? {
    
    return UserDefaults.standard.string(forKey: "VinePassword")
    
}

func save(birthday: Double?)  {
    
    UserDefaults.standard.set(birthday, forKey: "birthday")
    UserDefaults.standard.synchronize()
}

func getBirthday() -> Double {
    
    return UserDefaults.standard.double(forKey: "birthday")
}

func save(password: String?)  {
    
    UserDefaults.standard.set(password, forKey: "password")
    UserDefaults.standard.synchronize()
}

func getPassword() -> String? {
    
    return UserDefaults.standard.string(forKey: "password")
}

func save(phoneNumber: String?)  {
    
    UserDefaults.standard.set(phoneNumber, forKey: "phonenumber")
    UserDefaults.standard.synchronize()
}

func getPhoneNumber() -> String? {
    
    return UserDefaults.standard.string(forKey: "phonenumber")
    
}

func save(verificationCode: String?)  {
    
    UserDefaults.standard.set(verificationCode, forKey: "verificationCodeForForgotPassword")
    UserDefaults.standard.synchronize()
}

func getVerificationCodeForForgotPassword() -> String? {
    
    return UserDefaults.standard.string(forKey: "verificationCodeForForgotPassword")
    
}


/// Use this on viewdidappear in order to make note of the last active screen the user was on. (Used in order to determine what screen the user is on when they are pulling to refresh)
///
/// - Parameter screen: Screen the user is on
func save(screen: Screen){
    
    var screenString = ""
    
    switch screen{
        case .UserProfileScreen:
        screenString = "UserProfileScreen"
        break
    case .SearchedUserProfileScreen:
        screenString = "SearchedUserProfileScreen"
        break
        
    case .NotificationsScreen:
        screenString = "NotificationsScreen"
        break
    
    case .SwapsScreen:
        screenString = "SwapsScreen"
        break
        
    case .SwappedScreen:
        screenString = "SwappedScreen"
        break
        
        
    }
    
    UserDefaults.standard.set(screenString, forKey: "LastScreen")
    UserDefaults.standard.synchronize()
}

/// Use this in order to determine what screen the user is currently on in order to determine what screen to refresh when the user pulls to refresh
func getLastScreen() -> Screen?{
    
    if let  screenString  = UserDefaults.standard.string(forKey: "LastScreen"){
        
        switch screenString {
        case "UserProfileScreen":
            
            return .UserProfileScreen
            
        case "SearchedUserProfileScreen":
            return .SearchedUserProfileScreen
            
        case "NotificationsScreen":
            return .NotificationsScreen
            
        case "SwapsScreen":
            return .SwapsScreen
            
        case "SwappedScreen":
            return .SwappedScreen
            
            
        default:
            return nil
        }
        
    } else {
        return nil
    }
    
    
}

/// Enum containing the type of screens the user was last active on
enum Screen{
    
    case UserProfileScreen
    case SearchedUserProfileScreen
    case NotificationsScreen
    case SwapsScreen
    case SwappedScreen
    
    
}
