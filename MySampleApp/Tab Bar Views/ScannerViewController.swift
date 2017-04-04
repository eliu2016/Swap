//
//  ScannerView.swift
//  Swap
//
//  Created by David Slakter on 1/7/17.
//
//

import Foundation
import SwiftQRCode
import AVFoundation
import Spring



let scanner = QRCode(autoRemoveSubLayers: false, lineWidth: CGFloat(nan: 0,signaling: true) , strokeColor: UIColor.clear, maxDetectedCount: 1)

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate{
    
    let imagePicker = UIImagePickerController()

    @IBOutlet var enableCameraLabel: UILabel!
    @IBOutlet var enableCameraButton: UIButton!
    
  
    @IBOutlet var blurView: UIVisualEffectView!

    @IBOutlet var confirmSwapView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var verifiedIcon: UIImageView!
   // @IBOutlet var blurView: UIVisualEffectView!

    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imagePicker.delegate = self
        
        setupViewController()
      
        handleCaseOfDisabledCamera()
        
        setupSwapScanner()

    }
    
    @IBAction func enableCamera(_ sender: Any) {
    
        UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
    }
   

    @IBAction func uploadSwapCode(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
   
    func setupViewController()  {
        
        //sets up swap confirm view
        self.view.addSubview(confirmSwapView)
        confirmSwapView.backgroundColor = UIColor.clear
        confirmSwapView.alpha = 0
        confirmSwapView.center = CGPoint(x: self.view.center.x, y: self.view.center.y+200)
        
        //recognizes a tap anywhere on the screen
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        circularImageNoBorder(photoImageView: profilePic)

        blurView.isHidden = true
        
        enableCameraLabel.isHidden = true
        enableCameraButton.isHidden = true
    }
    
    func didTapScreen(){
        
        blurView.isHidden = true
        
        // User has tapped the screen
        UIView.animate(withDuration: 0.2, animations: {
            
            self.confirmSwapView.alpha = 0
            self.confirmSwapView.transform = CGAffineTransform.init(translationX: 0, y: 200)
            
            
        })
        
        scanner.startScan()
        
    }
    
    func animateInSwapView(){
        
        blurView.isHidden = false
        
        UIView.animate(withDuration: 0.25){
            
            self.confirmSwapView.alpha = 1
            self.confirmSwapView.transform = CGAffineTransform.init(translationX: 0, y: -200)
        }
        
    }
    
    func handleCaseOfDisabledCamera()  {
        
        
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType:
            AVMediaTypeVideo)
        
        switch authStatus {
        case .authorized: break
        case .denied:
            
            enableCameraLabel.isHidden = false
            enableCameraButton.isHidden = false
            
            break
            
        default: break
        }
    }
    
    func setupSwapScanner()  {
        
        scanner.prepareScan(self.view){ (swapLink) in
            
            
            let username = getUsernameFromSwapLink(swapLink: swapLink)
            
            SwapUser().swap(with: username, authorizeOnViewController: self, completion: { (error, user) in
                
              
                
                if error != nil {
                    
                    // There was an error trying to get the user from the swap code
                    self.animateInSwapView()
                    self.nameLabel.text = "User Not Found"
                    self.bioLabel.text = ""
                    self.verifiedIcon.isHidden = true
                    
                    
                    // Restart Scanner After Showing Pop Up View
                    scanner.startScan()
                    
                }
                
                
                if let user = user {
                    
                    if user._isPrivate?.boolValue ?? false{
                        
                        //the user is private; notify the user that a request was sent.
                        self.animateInSwapView()
                        
                        let fullString = NSMutableAttributedString(string: "")
                        
                        let lockedImageAttachment = NSTextAttachment()
                        lockedImageAttachment.image =  #imageLiteral(resourceName: "LockIcon")
                        
                        let lockedImageString = NSAttributedString(attachment: lockedImageAttachment)
                        
                        
                        let nameString = NSMutableAttributedString(string: " \(user._firstname ?? "") \(user._lastname ?? "")")
                        
                        fullString.append(lockedImageString)
                        fullString.append(nameString)
                        
                       
                       
                        self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl ?? defaultImage))
                        
                        self.nameLabel.attributedText = fullString
                        
                        self.bioLabel.text = user._bio ?? ""
                        
                        if !(user._isVerified as? Bool ?? false){
                            
                            self.verifiedIcon.isHidden = true
                        }
                        else{
                            self.verifiedIcon.isHidden = false
                        }
            
                    }
                        
                    else{
                        
                        
                        //notify the user that swap was sucessful
                        self.animateInSwapView()
                    
                        
                        self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl ?? defaultImage))
                        
                        self.nameLabel.text = "\(user._firstname ?? "") \(user._lastname ?? "")"
                        
                        self.bioLabel.text = user._bio ?? ""
                        
                        if !(user._isVerified as? Bool ?? false){
                            
                            self.verifiedIcon.isHidden = true
                        }
                        else{
                            self.verifiedIcon.isHidden = false
                        }

                    }
                    
                }
                
                
            })
            
        }
        
        scanner.scanFrame = view.bounds
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        if let pickedimage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            
            
            let swapLink = swapCodeLinkFrom(Image: pickedimage)
            let usernameFromSwapCode = getUsernameFromSwapLink(swapLink: swapLink)
            
            
            
            SwapUser().swap(with: usernameFromSwapCode, authorizeOnViewController: self, completion: { (error, user) in
                
                guard error == nil, let user = user else {
                    // User Not Found
                    // There was an error trying to get the user from the swap code
                    self.animateInSwapView()
                    self.nameLabel.text = "User Not Found"
                    self.bioLabel.text = ""
                    self.verifiedIcon.isHidden = true
                    
                    return
                }
                
                
                if user._isPrivate?.boolValue ?? false{
                    
                    //the user is private; notify the user that a request was sent.
                    self.animateInSwapView()
                    
                    let fullString = NSMutableAttributedString(string: "")
                    
                    let lockedImageAttachment = NSTextAttachment()
                    lockedImageAttachment.image =  #imageLiteral(resourceName: "LockIcon")
                    
                    let lockedImageString = NSAttributedString(attachment: lockedImageAttachment)
                    
                    
                    let nameString = NSMutableAttributedString(string: " \(user._firstname ?? "") \(user._lastname ?? "")")
                    
                    fullString.append(lockedImageString)
                    fullString.append(nameString)
                    
                    
                    
                    self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl ?? defaultImage))
                    
                    self.nameLabel.attributedText = fullString
                    
                    self.bioLabel.text = user._bio ?? ""
                    
                    if !(user._isVerified as? Bool ?? false){
                        
                        self.verifiedIcon.isHidden = true
                    }
                    else{
                        self.verifiedIcon.isHidden = false
                    }
                    
                }
                    
                else{
                    
                    
                    //notify the user that swap was sucessful
                    self.animateInSwapView()
                    
                    
                    self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl ?? defaultImage))
                    
                    self.nameLabel.text = "\(user._firstname ?? "") \(user._lastname ?? "")"
                    
                    self.bioLabel.text = user._bio ?? ""
                    
                    if !(user._isVerified as? Bool ?? false){
                        
                        self.verifiedIcon.isHidden = true
                    }
                    else{
                        self.verifiedIcon.isHidden = false
                    }
                    
                }
                
                
                
            })
            
            
        }
        else{
            print("error selecting picture")
        }

        
    }

}

func getUsernameFromSwapLink(swapLink: String) -> String {
    
    return (swapLink as NSString).lastPathComponent.lowercased()
    
}



/// Returns the swap link from a Swap Code read from an UIImage. Will return "" if none is      found.
func swapCodeLinkFrom(Image image: UIImage) -> String {
    
    var swapLink = ""
    
    
    var detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    
    if let detector = detector{
        
        
        if let ciimage = CIImage(image: image){
            
            var features = detector.features(in: ciimage)
            
            for feature in features{
                
                let decodedCode = (feature as! CIQRCodeFeature).messageString
                
                swapLink = decodedCode ?? ""
            }
            
        }
        
        
    }
    
    return swapLink
    
}
