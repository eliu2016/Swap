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
    var swapPin: SwapsAnnotation!
    var locationManager = CLLocationManager()
    var NewYorkCity = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059)//defaults to New York City
    
    override func viewDidLoad() {
        
        // Listens for reloadProfile notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMap), name: .reloadMap, object: nil)
    
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        addPins()
        
        locationManager.startUpdatingLocation()
     
        let region = MKCoordinateRegionForMapRect(MKMapRectWorld)
        mapView.setRegion(region, animated: true)
        
    }
    
    ///This  will remove all pins on the map and reload the pins based on the Swap History that is already cached locally. It will NOT pull new swap history via API, only use what is already stored locally.
    func reloadMap()  {
        
        
        //Remove all added annotations
        mapView.removeAnnotations(mapView.annotations)
        
       addPins()
        

            
        
        
        
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
         
      // ******* Creates Random Pins ****************************************************
            
            
            
 // ************************************************************

           if let x_cordinate_string = history._latitude, let y_cordinate_string = history._longitude{
            print("I have cordinates")
                     let x_cordinate = Double(x_cordinate_string)
                     let y_cordinate = Double(y_cordinate_string)
            print("X_Cordinate: \(x_cordinate)\nY_Cordinate: \(y_cordinate)")
                    // Ensure there are cordinates presents
            
                    if let x = x_cordinate, let y = y_cordinate{
                
                               // Add Annotations
                    print("creating pin")
                        swapPin = SwapsAnnotation()
                        swapPin.coordinate = CLLocationCoordinate2D(latitude: x , longitude: y )
                        swapPin.title = history._swapped ?? ""
                                        
                        mapView.addAnnotation(swapPin)
                    
            }
            
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        var identifier = "pinID"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            print("ANNOTATION TITILE: \(annotation.title!!)")
            
            let swapPinView = self.createAnnotationView(from: (annotation.title ?? "")!)
            annotationView! = swapPinView
            
        }
        else {
            annotationView?.annotation = annotation
        }
        
       
        
        return annotationView
    }
    
    /// Creates an annotation view from a username
    func createAnnotationView(from username: String) -> MKAnnotationView{
        
        var AnnotationView = MKAnnotationView()
        
        var pinImageView = UIImageView(image: #imageLiteral(resourceName: "SwapAnnotationIcon"))
        var profilePicImageView = UIImageView()
        
        
        
        profilePicImageView.kf.indicatorType = .activity
        
        
        // Check if there's an image saved in user defaults for the user 
        
        if let profilePicture = getSwapMapProfilePictureFromUser(with: username){
            
            print("Profile Picture Saved in User Defaults")
            
           
            
            profilePicImageView.kf.setImage(with: URL(string: profilePicture))
            
            
        }
        
        else{
            
            print("No Profile Picture Saved in User Defaults")
            
            // No Image Saved... download it
            
            
            SwapUser(username: username).getInformation { (error, user) in
                
                
                if let user = user {
                    
                    
                    profilePicImageView.kf.setImage(with: URL(string: user._profilePictureUrl ?? ""))
                    
                    
                    // Save the image
                    if let picture = user._profilePictureUrl{
                        
                        saveMapProfilePictureToUser(username: username, pictureURL: picture)
                        
                    }
                    
                    
                }  else{
                    
                    profilePicImageView.image = #imageLiteral(resourceName: "DefaultProfileImage")
                }
            }
            
        }
        
        DispatchQueue.main.async {
            
            circularImageNoBorder(photoImageView: profilePicImageView)
        }
        
        if (self.storyboard?.value(forKey: "name") as! String == "IPhone7Plus"){
             profilePicImageView.frame = CGRect(x: profilePicImageView.center.x + 15, y: profilePicImageView.center.y - 32, width: profilePicImageView.frame.width - 41, height: profilePicImageView.frame.height - 41)
            
        }
        else{
                profilePicImageView.frame = CGRect(x: profilePicImageView.center.x + 22, y: profilePicImageView.center.y - 25, width: profilePicImageView.frame.width - 44, height: profilePicImageView.frame.height - 44)
        }
        pinImageView.frame = CGRect(x: pinImageView.center.x - 62, y: pinImageView.center.y - 115, width: pinImageView.frame.width, height: pinImageView.frame.height)
        AnnotationView.addSubview(pinImageView)
        AnnotationView.addSubview(profilePicImageView)
        
        return AnnotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("DID TAP PIN")
        
        if let annotation = view.annotation as? SwapsAnnotation{
            print(annotation.title)
        }
    }
    
    
}

