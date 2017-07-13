//
//  SwappedAnnotation.swift
//  Swap
//
//  Created by David Slakter on 7/11/17.
//
//

import Foundation
import MapKit

class SwapsAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var image: UIImage!
    var title: String?
    
    init(image : UIImage, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.image = image
    }
}
