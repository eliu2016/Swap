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

class SwapMapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var moreInfoView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var swappedMedia1: UIImageView!
    @IBOutlet var swappedMedia2: UIImageView!
    @IBOutlet var swappedMedia3: UIImageView!
    @IBOutlet var swappedMedia4: UIImageView!
    @IBOutlet var swappedMedia5: UIImageView!
    @IBOutlet var swappedMedia6: UIImageView!
    @IBOutlet var swappedMedia7: UIImageView!
    @IBOutlet var swappedMedia8: UIImageView!
    @IBOutlet var swappedMedia9: UIImageView!
    
    var sharedSocialMedias: [UIImage] = []
    
    var swapPin: SwapsAnnotation!
    var locationManager = CLLocationManager()
    var NewYorkCity = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0059)//defaults to New York City
    
    override func viewDidLoad() {
        
        blurView.isHidden = true
        circularImageNoBorder(photoImageView: profilePicture)
        
        // Listens for reloadProfile notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMap), name: .reloadMap, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pinSelected), name: .showPinInfo, object: nil)

    
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
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
                
               
            })
            
            
            query?.observeReady({
                
                guard nearbyUsers.count > 0 else {
                    return
                }
                let alert = UIAlertController(title: "Nearby User Found", message: "\(nearbyUsers) found  near you", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                // Called when query is complete
            })
        }
     
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
   
   
    
 
    
    
}

