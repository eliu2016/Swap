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

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate{
    
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
    
        
        setupViewController()
      
        handleCaseOfDisabledCamera()
        
        setupSwapScanner()

    }
    
    @IBAction func enableCamera(_ sender: Any) {
    
        UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
    }
   

    @IBAction func uploadSwapCode(_ sender: Any) {
        
        
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
        UIView.animate(withDuration: 0.4, animations: {
            
            self.confirmSwapView.alpha = 0
            self.confirmSwapView.transform = CGAffineTransform.init(translationX: 0, y: 200)
            
            
        })
        
        scanner.startScan()
        
    }
    
    func animateInSwapView(){
        
        blurView.isHidden = false
        
        UIView.animate(withDuration: 0.4){
            
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
                
                scanner.stopScan()
                
                if error != nil {
                    
                    // There was an error trying to get the user from the swap code
                    
                    
                    
                    
                    // Restart Scanner After Showing Pop Up View
                    scanner.startScan()
                    
                }
                
                
                if let user = user {
                    
                    if user._isPrivate?.boolValue ?? false{
                        
                        //the user is private; notify the user that a request was sent.
                        self.animateInSwapView()
                        
                        
                        let lockedImageAttachment = NSTextAttachment()
                        lockedImageAttachment.image =  #imageLiteral(resourceName: "LockIcon")
                        let lockString = NSAttributedString(attachment: lockedImageAttachment)
                        let nameString = NSMutableAttributedString(string: "\(lockString)")
                         let name = NSAttributedString(string: user._firstname! + " " + user._lastname!)
                        print("THIS IS THE STRING \(nameString)")
                        //nameString.append(name)
                        
                       
                        self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl!))
                        
                        self.nameLabel.attributedText = nameString
                        
                        self.bioLabel.text = user._bio!
                        
                        if !(user._isVerified as? Bool ?? false){
                            
                            self.verifiedIcon.isHidden = true
                        }
            
                    }
                        
                    else{
                        
                        
                        //notify the user that swap was sucessful
                        self.animateInSwapView()
                    
                        
                        self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl!))
                        
                        self.nameLabel.text = "\(user._firstname!) \(user._lastname!)"
                        
                        self.bioLabel.text = user._bio!
                        
                        if !(user._isVerified as? Bool ?? false){
                            
                            self.verifiedIcon.isHidden = true
                        }

                    }
                    
                }
                
                
            })
            
        }
        
        scanner.scanFrame = view.bounds
    }

}

func getUsernameFromSwapLink(swapLink: String) -> String {
    
    return (swapLink as NSString).lastPathComponent.lowercased()
    
}

func fall(imageView: UIImageView){
    let layer = imageView as! SpringImageView
    layer.animation = "fall"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}


 func fall(button: UIButton)  {
    let layer = button as! SpringButton
    layer.animation = "fall"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}

func fall(label: UILabel){
    let layer = label as! SpringLabel
    layer.animation = "fall"
    layer.curve = "easeIn"
    layer.duration = 1.0
    layer.animate()
}
