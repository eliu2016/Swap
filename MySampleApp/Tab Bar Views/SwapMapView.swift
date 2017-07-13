//
//  StoriesView.swift
//  Swap
//
//  Created by David Slakter on 1/31/17.
//
//

import Foundation
import MapKit

class SwapMapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    var swapPinView = MKAnnotationView()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059)//defaults to New York City
    
    override func viewDidLoad() {
    
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        addPins()
        
        locationManager.startUpdatingLocation()
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
    }
    
    //Center the map on the user's location when the view appears
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        var currentLocation = manager.location!.coordinate
        
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
       
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
    }
  
    ///   Adds pins on map that show locations of where you swapped users
    func addPins()  {
        
        for history in swapHistoryUsers{
      
            /*
                 +            let rand = drand48()   / 100
                 +            history._latitude = (mapView.userLocation.coordinate.latitude != 0) ? "\(mapView.userLocation.coordinate.latitude)" :  "40.7128"
                 +            history._longitude = (mapView.userLocation.coordinate.longitude != 0) ? "\(mapView.userLocation.coordinate.longitude)" :  "-74.0059"
                */
            
           if let x_cordinate_string = history._latitude, let y_cordinate_string = history._longitude{
            
                     let x_cordinate = Double(x_cordinate_string)
                     let y_cordinate = Double(y_cordinate_string)
            
                    // Ensure there are cordinates presents
            
                    if let x = x_cordinate, let y = y_cordinate{
                
                               // Add Annotations
                    
                        var annotation = SwapsAnnotation(image: #imageLiteral(resourceName: "InstagramDisabled"), coordinate: CLLocationCoordinate2DMake(x, y))
                                        // ***DELETE RAND IN PRODUCTION
                                        annotation.title = history._swapped ?? ""
                                        
                                        mapView.addAnnotation(annotation)
                    
            }
            
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationIdentifier")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationIdentifier")
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView! = swapPinView
        return annotationView
    }
}

