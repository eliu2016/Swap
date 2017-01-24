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


let scanner = QRCode(autoRemoveSubLayers: false, lineWidth: CGFloat(nan: 0,signaling: true) , strokeColor: UIColor.clear, maxDetectedCount: 1)

class ScannerViewController: UIViewController {

    
    @IBOutlet var enableCameraLabel: UILabel!
    @IBOutlet var enableCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            
            
            SwapUser(username: username).getInformation(completion: { (error, user) in
                
                // Stop Scanner
                scanner.stopScan()
                
                
                if error != nil {
                    
                    // There was an error trying to get the user from the swap code
                    
                    print("Could not get user.. Not a valid Swap Code... User does not exist...or bad internet connection")
                    
                    
                    // Restart Scanner After Showing Pop Up View
                    scanner.startScan()
                    
                    
                }
                
                
                if let user = user{
                    
                    // Could get user
                    
                    let userIsPrivate = user._isPrivate as! Bool
                    
                    if userIsPrivate{
                        
                        SwapUser(username: getUsernameOfSignedInUser()).sendSwapRequest(toSwapUser:  SwapUser(username: user._username!), completion: { error in
                            
                            if error != nil {
                                
                                // Some error happened
                             
                                scanner.startScan()
                                
                            }  else{
                                // Request Sent
                                
                            
                                scanner.startScan()
                                
                                // Log analytics
                                Analytics.didSwap(byMethod: .swapcode, isPrivate: true)
                              
                               
                            }
                            
                            
                        })
                        
                    }
                        
                    else{
                        
                        // Share social medias
                        shareVine(withUser: user)
                        shareSpotify(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        createContactInPhone(withContactDataOfUser: user, completion: {_ in return })
                        shareInstagram(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        shareTwitter(withUser: user)
                        shareYouTube(withUser: user)
                        shareSoundCloud(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        sharePinterest(withUser: user, andIfNeededAuthorizeOnViewController: self)
                        
                        
                        
                        SwapUser(username: user._username!).sendSwappedNotification(bySwapUser: SwapUser(username: getUsernameOfSignedInUser()))
                        // Start Scanner back
                        scanner.startScan()
                        
                        
                        // Log Analytics
                        Analytics.didSwap(byMethod: .swapcode, didShareSpotify: false, didSharePhone: true, didShareEmail: true, didShareInstagram: false, didShareSnapchat: true, didShareTwitter: false, didShareYouTube: true, didShareSoundCloud: true, didSharePinterest: false)
                        
                        
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
    
}


func getUsernameFromSwapLink(swapLink: String) -> String {
    
    return (swapLink as NSString).lastPathComponent
    
    
}
