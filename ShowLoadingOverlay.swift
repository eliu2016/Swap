//
//  ShowLoadingOverlay.swift
//  Swap
//
//  Created by David Slakter on 12/25/16.
//
//

import Foundation


class ShowLoadingOverlay {
    
    var imageView: UIImageView!
    
    func showBlackOverlay() -> UIImageView {
        
        let image = UIImage(named: "GrayOverlay")
        let blackOverlay = UIImageView(image: image!)
        blackOverlay.alpha = 0.5
        blackOverlay.frame = CGRect(x: -300, y: -100, width: 1000, height: 1000)
        
        return blackOverlay
    }
    
    func showLoadingSymbol() -> UIImageView {
        
        let image = UIImage(named: "LoadingSymbol")
        let loadingSymbol = UIImageView(image: image!)
        loadingSymbol.frame = CGRect(x: 171, y: 318, width: 35, height: 35)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2 * M_PI
        rotationAnimation.repeatCount = 180
        rotationAnimation.duration = 1.0
        
        loadingSymbol.layer.add(rotationAnimation, forKey: nil)
        
        
        
        return loadingSymbol

    }
}
