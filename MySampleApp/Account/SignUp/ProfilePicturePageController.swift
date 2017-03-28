//
//  ProfilePicturePageController.swift
//  Swap
//
//  Created by David Slakter on 3/24/17.
//
//

import Foundation
import Kingfisher


var currentIndex = 0

class ProfilePicPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var instagramPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var twitterPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var youtubePicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var contactPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
 
    
    var pictureViews = [UIViewController]()
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let instagramPic = getInstagramProfilePictureLink(){
            
            instagramPicView.imageURL = instagramPic
        }
        
        if let twitterPic = getTwitterProfilePictureLink(){
            
            twitterPicView.imageURL = twitterPic
        }
        
        if let youtubePic = getYouTubeProfilePictureLink(){
            
            youtubePicView.imageURL = youtubePic
        }
        
       // contactPicView.imageURL  =  getContactImage()
        pictureViews = [instagramPicView, twitterPicView, youtubePicView, contactPicView]
        
        dataSource = self
        delegate = self
        
        if let firstViewController = pictureViews.first {
            
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
   
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed{
            
            currentIndex = pictureViews.index(of: (viewControllers?.first)!)!
            
            NotificationCenter.default.post(name: .updatePageControl, object: nil)
        }
    }
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
    
    var imageURL: URL!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if imageURL == nil{
            
            picture.image = #imageLiteral(resourceName: "DefaultProfileImage")
        }
        else{
            
            picture.kf.setImage(with: imageURL)
        }
        
        circularImage(photoImageView: picture)
        
        image = picture.image
    }
    
}

class SelectProfilePicViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    var currentImage: UIImage?
    var link: String?
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePageControl), name: .updatePageControl, object: nil)
    }
   
        
    
    func updatePageControl(){
        
        pageControl.currentPage = currentIndex
    }
    
       
    @IBAction func didSelectPicture(_ sender: Any) {
        
        switch currentIndex {
        case 0:
            link = "\(getInstagramProfilePictureLink())"
            break
        case 1:
            link = "\(getTwitterProfilePictureLink())"
            break
        case 2:
            link = "\(getYouTubeProfilePictureLink())"
            break
        case 3:
            currentImage = getContactImage() ?? #imageLiteral(resourceName: "DefaultProfileImage")
            break
        default:
            currentImage = #imageLiteral(resourceName: "DefaultProfileImage")
        }
        
        if let selectedLink = link{
        
            SwapUser().set(ProfileImage: link,  DidSetInformation: {
        
                DispatchQueue.main.async {

                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            })
        }
        else {
            
            let imageData = UIImageJPEGRepresentation(currentImage!, 1.0)
            SwapUser().uploadProfilePicture(withData: imageData!, completion: {_ in 
            
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            })
        }
    
        
    }

}

