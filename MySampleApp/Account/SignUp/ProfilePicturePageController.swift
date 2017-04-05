//
//  ProfilePicturePageController.swift
//  Swap
//
//  Created by David Slakter on 3/24/17.
//
//  File holds all the classes neccessay for the user to select a profile picture from the available logged in social medias. 

import Foundation
import Kingfisher


var currentIndex = 0

//view that holds all the available profile pictures in a PageViewController
class ProfilePicPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var instagramPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var twitterPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var youtubePicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var contactPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
 
    
    var pictureViews = [UIViewController]()
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        instagramPicView.imageURL = getInstagramProfilePictureLink() ?? URL(string: defaultImage)!
        twitterPicView.imageURL = getTwitterProfilePictureLink() ?? URL(string: defaultImage)!
        youtubePicView.imageURL = getYouTubeProfilePictureLink() ?? URL(string: defaultImage)!
        contactPicView.imageURL = (getContactImage() != nil) ? nil : URL(string: defaultImage)!
        
        
        
        
     
       
        pictureViews = [instagramPicView, twitterPicView, youtubePicView, contactPicView]
        
        dataSource = self
        delegate = self
        
        //set the first controller in the pageViewController
        if let firstViewController = pictureViews.first {
            
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
   
    }
    
     /*Delegate function*/
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //only execute if the transition from one page to the next is completed
        if completed{
            
            //update the current index and the page Control
            currentIndex = pictureViews.index(of: (viewControllers?.first)!)!
            NotificationCenter.default.post(name: .updatePageControl, object: nil)
        }
    }
    
    /*Data Source Function*/
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
        guard let viewControllerIndex = pictureViews.index(of: viewController) else {
            
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
      
            return pictureViews.last
        }
        
        guard pictureViews.count > previousIndex else {
            
            return nil
        }
        
  
        return pictureViews[previousIndex]
       
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        
        guard let viewControllerIndex = pictureViews.index(of: viewController) else {
            
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let pictureViewsCount = pictureViews.count
        
        guard pictureViewsCount != nextIndex else{
            
            return pictureViews.first
        }
        
        guard pictureViewsCount > nextIndex else{
            return nil
        }
    
        return pictureViews[nextIndex]
    
    }
    

    
}


class ProfilePicView: UIViewController {
    
    @IBOutlet var picture: UIImageView!
    
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if imageURL == nil{
            
            picture.image = getContactImage() ?? #imageLiteral(resourceName: "DefaultProfileImage")
        }
        else{
            
            picture.kf.setImage(with: imageURL)
        }
        
        circularImage(photoImageView: picture)
        
    }
    
}

//View that holds the pageViewController
class SelectProfilePicViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    var currentImage: UIImage?
    var link: URL?
    
    override func viewDidLoad() {
        currentIndex = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePageControl), name: .updatePageControl, object: nil)
    }
   
        
    
    func updatePageControl(){
        
        pageControl.currentPage = currentIndex
    }
    
    
    @IBAction func didSelectPicture(_ sender: Any) {
        
        switch currentIndex {
        case 0:
            link = getInstagramProfilePictureLink()
            break
        case 1:
            link = getTwitterProfilePictureLink()
            break
        case 2:
            link = getYouTubeProfilePictureLink()
            break
        case 3:
            currentImage = getContactImage() ?? #imageLiteral(resourceName: "DefaultProfileImage")
            break
        default:
            currentImage = #imageLiteral(resourceName: "DefaultProfileImage")
        }
        
        if let selectedLink = link{
            
            SwapUser().set(ProfileImage: "\(selectedLink)",  DidSetInformation: {

                DispatchQueue.main.async {

                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            })
        }
        else {
    
            let imageData = UIImageJPEGRepresentation(currentImage ?? #imageLiteral(resourceName: "DefaultProfileImage"), 1.0)
            SwapUser().uploadProfilePicture(withData: imageData!, completion: {_ in 
            
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            })
        }
    
        
    }

}

