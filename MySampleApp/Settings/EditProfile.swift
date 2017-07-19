//
//  EditProfile.swift
//  Swap
//
//  Created by David Slakter on 1/10/17.
//
//

import Foundation
import Kingfisher

var editProfileFirstName = ""
var editProfileLastName = ""
var editProfileEmail = ""
var editProfileBirthday = 0.0

class EditProfile: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    
  
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var doneActivityView: UIActivityIndicatorView!
    
    var didChangeProfilePicture: Bool = false
    
    
    override func viewDidLoad() {
        
       circularImageNoBorder(photoImageView: profilePicture)
       imagePicker.delegate = self
       doneActivityView.stopAnimating()
       
        activityView.startAnimating()
       
        SwapUser(username: getUsernameOfSignedInUser()).getInformation { (error, user) in
            
            DispatchQueue.main.async {
            
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
                
            }
            self.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
          
        }
        
        
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didPressDone(_ sender: Any) {
    
        print("DID CHANGE PROFILE PICTURE: \(didChangeProfilePicture)")
        
        let firstName = editProfileFirstName
        let lastName = editProfileLastName
        let email = editProfileEmail
        let birthday = editProfileBirthday
        let imageData = UIImageJPEGRepresentation(profilePicture.image!, 1.0)

        doneActivityView.isHidden = false
        doneActivityView.startAnimating()
        doneButton.isHidden = true
        
        if didChangeProfilePicture{
            
            SwapUser().uploadProfilePicture(withData: imageData!, completion:
                {_ in
                    
                    SwapUser().set(Firstname: firstName, Lastname: lastName, Email: email, Birthday: birthday,  DidSetInformation: {
                        
                        DispatchQueue.main.async {
                            
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: .reloadProfile, object: nil)
                        }
                        
                    }, CannotSetInformation: {
                        
                        print("error setting basic profile info")
                    })
                    
            })
        }
        
        SwapUser().set(Firstname: firstName, Lastname: lastName, Email: email, Birthday: birthday,  DidSetInformation: {
            
            DispatchQueue.main.async {
                
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .reloadProfile, object: nil)
                
            }
            
        }, CannotSetInformation: {
            
            print("error setting basic profile info")
        })
       
        
    }
    
    @IBAction func changePicture(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let pickedimage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            didChangeProfilePicture = true
            profilePicture.image = pickedimage
        }
        else{
            print("error selecting picture")
        }
        
    }
    
    
    func resizeImage(image: UIImage) -> UIImage {
        
        var newWidth: CGFloat
        let newHeight: CGFloat
        
        if image.size.width < 180{
            newWidth = image.size.width
            newHeight  = image.size.height
        }
        else{
            newWidth = 180
            newHeight  = (newWidth * image.size.height)/image.size.width
        }
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        
        return scaledImage!
        
    }


}

class EditProfileTable: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet public var firstNameField: UITextField!
    @IBOutlet public var lastNameField: UITextField!
    @IBOutlet public var emailField: UITextField!
    @IBOutlet public var birthdayField: UITextField!
    @IBOutlet public var birthdayPicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        
        SwapUser(username: getUsernameOfSignedInUser()).getInformation { (error, user) in
            
            DispatchQueue.main.async {
                
                self.firstNameField.text = user?._firstname
                self.lastNameField.text = user?._lastname
                self.emailField.text = user?._email
                self.birthdayPicker.date =  NSDate(timeIntervalSince1970: user?._birthday as! TimeInterval) as Date

                editProfileFirstName = (user?._firstname)!
                editProfileLastName = (user?._lastname)!
                editProfileEmail = (user?._email)!
                editProfileBirthday = self.birthdayPicker.date.timeIntervalSince1970 as Double
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateStyle = DateFormatter.Style.medium
                
                dateFormatter.timeStyle = DateFormatter.Style.none
                
                self.birthdayField.text = dateFormatter.string(from: self.birthdayPicker.date)
            }
            
        }
    }
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
        emailField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        birthdayPicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        editProfileBirthday = birthdayPicker.date.timeIntervalSince1970 as Double
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        birthdayField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        if textField.tag == 2{
            tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + 70), animated: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //set global information
        
        editProfileFirstName = firstNameField.text!
        editProfileLastName =  lastNameField.text!
        editProfileEmail = emailField.text!
        

        if textField.tag == 2{
            tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y - 70), animated: true)
        }
    }
    
}


