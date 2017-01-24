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

//let scanner = QRCode(autoRemoveSubLayers: false, lineWidth: CGFloat(nan: 0,signaling: true)
//    , strokeColor: UIColor.clear, maxDetectedCount: 1)

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
        
        
//        scanner.prepareScan(self.view){ (stringValue) in
//            print(stringValue)
//            
//        }
//        scanner.scanFrame = view.bounds
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // scanner.startScan()
       
    }
    
    @IBAction func enableCamera(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        
    }
    
}
