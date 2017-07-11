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
        
        
       
        
        setupMap()
        addPins()
        
        
        
        
    }
    
    
    
  
    
 ///   Adds pins on map that show locations of where you swapped users
    func addPins()  {
        
        for history in swapHistoryUsers{
            
            
 
            /*
            let rand = drand48()   / 100
            history._latitude = (mapView.userLocation.coordinate.latitude != 0) ? "\(mapView.userLocation.coordinate.latitude)" :  "40.7128"
            history._longitude = (mapView.userLocation.coordinate.longitude != 0) ? "\(mapView.userLocation.coordinate.longitude)" :  "-74.0059"
           */
        
  
 
 
 
            if let x_cordinate_string = history._latitude, let y_cordinate_string = history._longitude{
                
                let x_cordinate = Double(x_cordinate_string)
                let y_cordinate = Double(y_cordinate_string)
                
                // Ensure there are cordinates presents
                
                if let x = x_cordinate, let y = y_cordinate{
                    
                    // Add Annotations
                    
                    var annotation = MKPointAnnotation()
                    // ***DELETE RAND IN PRODUCTION
                    annotation.coordinate = CLLocationCoordinate2DMake(x, y)
                    annotation.title = history._swapped ?? ""
    
                    mapView.addAnnotation(annotation)
                    
                }
                
                
                
            }
        }
    }
    
    /// Center's Map on User's Location. If there's no location, it defaults to New York City
    func setupMap()  {
        
        // Gets the user's location and centers map
        var currentLocation = mapView.userLocation.coordinate
        
        if currentLocation.latitude == 0 && currentLocation.longitude == 0 {
            // Set Location to default location
            
            let NewYorkCity = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059)
            currentLocation = NewYorkCity
        }
        
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
}













