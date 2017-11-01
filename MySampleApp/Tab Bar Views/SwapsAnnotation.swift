//
//  SwappedAnnotation.swift
//  Swap
//
//  Created by David Slakter on 7/11/17.
//
//

import Foundation
import MapKit

class SwapsAnnotation: MKPointAnnotation {
    
    var pinImage: UIImage?
    

}
class SwapsAnnotationView: MKAnnotationView {
    
    var title: String?
    
    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(false, animated: animated)
        
        if (selected){
            print("PIN SELECTED: \(title!)")
            
            NotificationCenter.default.post(name: .showPinInfo, object: nil)
            
        }
        
    }
    
}
