//
//  EditProfile.swift
//  Swap
//
//  Created by David Slakter on 1/10/17.
//
//

import Foundation

class EditProfile: UIViewController, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var profilePicture: UIImageView!
    
    @IBAction func didPressCancel(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePicture(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker:
        
        UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profilePicture.contentMode = .scaleAspectFill
            profilePicture.image = resizeImage(image: pickedImage)
    
        }
        
        dismiss(animated: true, completion: nil)
        
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
