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

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate{
    
    let imagePicker = UIImagePickerController()

    @IBOutlet var confirmSwapLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var confirmSwapButton: UIButton!
    @IBOutlet var enableCameraLabel: UILabel!
    @IBOutlet var enableCameraButton: UIButton!
    
    var confirmSwapBackground: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circularImage(photoImageView: profilePic)
        profilePic.isHidden = true
        confirmSwapLabel.isHidden = true
        confirmSwapButton.isHidden = true
        
        enableCameraLabel.isHidden = true
        enableCameraButton.isHidden = true
        
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
                        
                        self.confirmSwapBackground = self.newConfirmView()
                        self.view.addSubview(self.confirmSwapBackground!)
                        self.view.bringSubview(toFront: self.profilePic)
                        self.view.bringSubview(toFront: self.confirmSwapLabel)
                        self.view.bringSubview(toFront: self.confirmSwapButton)
                        
                        self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl!))
                        
                        self.confirmSwapLabel.text = "Request sent to " + user._firstname! + " " + user._lastname!
                        
                        self.profilePic.isHidden = false
                        self.confirmSwapLabel.isHidden = false
                        self.confirmSwapButton.isHidden = false
                        
                    }
                    
                    else{
                        
                        self.confirmSwapBackground = self.newConfirmView()
                        self.view.addSubview(self.confirmSwapBackground!)
                        
                        self.view.bringSubview(toFront: self.profilePic)
                        self.view.bringSubview(toFront: self.confirmSwapLabel)
                        self.view.bringSubview(toFront: self.confirmSwapButton)
                        
                        self.profilePic.kf.setImage(with: URL(string: user._profilePictureUrl!))
                        
                        self.confirmSwapLabel.text =  user._firstname! + " " + user._lastname!
                        
                        self.profilePic.isHidden = false
                        self.confirmSwapLabel.isHidden = false
                        self.confirmSwapButton.isHidden = false
                        
                    }
                    
                }
                
                
            })
            
            
            
            
            
            
            
        }
        
        scanner.scanFrame = view.bounds
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanner.startScan()
       
    }
    
    @IBAction func enableCamera(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        
    }
    @IBAction func didPressDone(_ sender: Any) {
        
        profilePic.isHidden = true
        confirmSwapLabel.isHidden = true
        confirmSwapButton.isHidden = true
        fall(imageView: confirmSwapBackground!)
        
        //restart the scanner
        scanner.startScan()
    }
    func newConfirmView() -> UIImageView {
        
        let image = #imageLiteral(resourceName: "ConfirmSwapBackground")
        let imageView = SpringImageView(image: image)
        
        let storyboardName = self.storyboard?.value(forKey: "name")
       
    
        let storyboardString = storyboardName as! String
        
        switch storyboardString {
        case "Main":
            imageView.frame = CGRect(x: 99, y: 180, width: 176, height: 151)
            break
            
        case "IPhone7Plus":
            imageView.frame = CGRect(x: 113, y: 198, width: 186, height: 170)
            break
            
        case "4in":
            imageView.frame = CGRect(x: 52, y: 241, width: 219, height: 103)
            break
            
        case "3.5in":
            imageView.frame = CGRect(x: 51, y: 195, width: 219, height: 103)
            break
            
        default:
            break
        }
        
        
        return imageView
    }
    @IBAction func uploadSwapCode(_ sender: Any) {
        
        
        
        
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
