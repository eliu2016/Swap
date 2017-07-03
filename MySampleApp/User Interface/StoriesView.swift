//
//  StoriesView.swift
//  Swap
//
//  Created by David Slakter on 1/31/17.
//
//

import Foundation
import MapKit

class StoriesView: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
        
        
    }
}
