//
//  EditProfile.swift
//  Swap
//
//  Created by David Slakter on 1/10/17.
//
//

import Foundation

class EditProfile: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    
  
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewDidLoad() {
        
       circularImage(photoImageView: profilePicture)
       imagePicker.delegate = self
       
        
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePicture(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let pickedimage = info[UIImagePickerControllerEditedImage] as? UIImage {
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
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var birthdayField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
        
            SwapUser(username: getUsernameOfSignedInUser()).getInformation { (error, user) in
            
                self.firstNameField.text = user?._firstname
                self.lastNameField.text = user?._lastname
                self.emailField.text = user?._email

            }
            
        }
    }
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
        emailField.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        if textField.tag == 2{
            tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + 50), animated: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 2{
            tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y - 50), animated: true)
        }
    }
    
}


