//
//  StoriesView.swift
//  Swap
//
//  Created by David Slakter on 1/31/17.
//
//

import Foundation
import MapKit
import Firebase
import GeoFire

// Reference to location database with live user locations
let geofireRef = Database.database().reference()

// Location Database
let locationDatabase = GeoFire(firebaseRef: geofireRef)


class PopularNearbyMapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var moreInfoView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    
    var swapPin: SwapsAnnotation!
    var NewYorkCity = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059)//defaults to New York City
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
    
    // Checks if Location Services Are Enabled
    if CLLocationManager.locationServicesEnabled() {
     switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
        // Tell the user that location services is disabled and take them to settings
            let alertView = UIAlertController(title: "Location Services Disabled", message: "Enable location to see popular profiles around you", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        
            //locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
        
            print("Can always access location (this is what we need)")
        
         case .authorizedWhenInUse:
         
            print("Only when in use. We need access always")
        }
    } else {
        print("Location services are not enabled")
}

        
        blurView.isHidden = true
        circularImageNoBorder(photoImageView: profilePicture)
        
        // Listens for reloadProfile notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMap), name: .reloadMap, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pinSelected), name: .showPinInfo, object: nil)

    
        mapView.delegate = self
        
     
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        } else {
            // Fallback on earlier versions
        }
        
        
        //addPins()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.distanceFilter = 10
        let region = MKCoordinateRegionForMapRect(MKMapRectWorld)
        mapView.setRegion(region, animated: true)
        
       
    }
    
    ///This  will remove all pins on the map and reload the pins
    func reloadMap()  {
        
        //Remove all added annotations
        mapView.removeAnnotations(mapView.annotations)
        
      // addPins()
        
    }
    
    //Center the map on the user's location when the view appears
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        var currentLocation = manager.location!.coordinate
        
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
       
        // Update User Location in Database
        if let location = locations.first{
               locationDatabase?.setLocation(location, forKey: getUsernameOfSignedInUser())
            
   
            ///******* TESTING POPULAR NEARBY *******
            var nearbyUsers: [String: Double] = [:]
            // Query Users Based on Location Radius
            //Key Entered: The location of a key now matches the query criteria.
            let radius = 0.2 // In Kilometers
            let query = locationDatabase?.query(at: location, withRadius: radius)
            
            
            query?.observe(.keyEntered, with: { (username, user_location) in
                
                guard username != getUsernameOfSignedInUser() else{
                    return
                }
                // Called whenever another user moves within a nearby location.
                print("Key Entered Event\n\n")
                var meters = user_location?.distance(from: location)
                
                nearbyUsers[username!] = meters
                
               // This is ran everytime a new user is found nearby
                // Add code to update swap map here
                
            })
            
            
            query?.observeReady({
                
                guard nearbyUsers.count > 0 else {
                    return
                }
                
                // Called when query is complete
                // This is called after ALL nearby users have been found
                
                
                
            })
        }
     
        mapView.showsUserLocation = true
        
        
        
    }
    func addNearbyUserPins() {
    
        
    }
    ///   Adds pins on map that show locations of where you swapped users
    func addPins()  {
       
        
        for history in swapHistoryUsers{
         
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
            annotationView = SwapsAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            print("ANNOTATION TITILE: \(annotation.title!!)")
            
            let swapPinView = self.createAnnotationView(from: (annotation.title ?? "")!)
            annotationView! = swapPinView
            annotationView!.canShowCallout = false
            
        }
        else {
            annotationView?.annotation = annotation
        }

        
        return annotationView
    }
    
    /// Creates an annotation view from a username
    func createAnnotationView(from username: String) -> MKAnnotationView{
        
        var AnnotationView = SwapsAnnotationView()
        
        var pinImageView = UIImageView(image: #imageLiteral(resourceName: "SwapAnnotationIcon"))
        var profilePicImageView = UIImageView()
        
        AnnotationView.title = username
        
        
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
             profilePicImageView.frame = CGRect(x: profilePicImageView.center.x + 15, y: profilePicImageView.center.y - 24, width: profilePicImageView.frame.width - 41, height: profilePicImageView.frame.height - 41)
            
        }
        else{
                profilePicImageView.frame = CGRect(x: profilePicImageView.center.x + 22, y: profilePicImageView.center.y - 20, width: profilePicImageView.frame.width - 44, height: profilePicImageView.frame.height - 44)
        }
        pinImageView.frame = CGRect(x: pinImageView.center.x - 62, y: pinImageView.center.y - 110, width: pinImageView.frame.width, height: pinImageView.frame.height)
        AnnotationView.addSubview(pinImageView)
        AnnotationView.addSubview(profilePicImageView)
        
        return AnnotationView
        
    }
    
    
    func pinSelected() {
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissMorePinInfo))
        blurView.isHidden = false
        blurView.addGestureRecognizer(dismissTap)
        
        moreInfoView.frame = CGRect(x: view.center.x - moreInfoView.frame.width/2, y: view.center.y - moreInfoView.frame.height/2, width: moreInfoView.frame.width, height: moreInfoView.frame.height)
        moreInfoView.backgroundColor = .clear
        view.addSubview(moreInfoView)
        
        for annotation in mapView.selectedAnnotations{
            
            
            
           SwapUser(username: annotation.title!!).getInformation(completion: { (error, user) in
            
            if error == nil{
                
                DispatchQueue.main.async {
                
                    self.nameLabel.text = "\(user?._firstname ?? "") \(user?._lastname ?? "")"
                    self.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
                    self.bioLabel.text = user?._bio ?? ""
                    
                    var metAt = ""
                    let geoCoder = CLGeocoder()
                    let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                        
                        // Place details
                        var placeMark: CLPlacemark!
                        placeMark = placemarks?[0]
                        
                        // Address dictionary
                        print(placeMark.addressDictionary as Any)
                        
                        
                        // Location name
                        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                            
                            metAt.append(locationName as String)
                            
                        }
                        // City
                        if let city = placeMark.addressDictionary!["City"] as? NSString {
                            
                            metAt.append(", \(city)")
                        }
                        
                        self.locationLabel.text = metAt
                       
                    })
                    
                    
            
                }
            }
            
            })
        }
    }
    
    func dismissMorePinInfo(){
        moreInfoView.removeFromSuperview()
        blurView.isHidden = true
        
        profilePicture.image = #imageLiteral(resourceName: "DefaultProfileImage")
        nameLabel.text = "Loading..."
        bioLabel.text = ""
        locationLabel.text = ""
        
    }
    
   
   
    
 func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

// Executed when there is an error in updating location
 }
    
}

