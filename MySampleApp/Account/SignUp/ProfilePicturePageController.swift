//
//  ProfilePicturePageController.swift
//  Swap
//
//  Created by David Slakter on 3/24/17.
//
//

import Foundation


class ProfilePicPageController: UIPageViewController, UIPageViewControllerDataSource {
    
    weak var pageControlDelegate: ProfilePicPageControlDelegate?
    
    var instagramPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var twitterPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var youtubePicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    var contactPicView = grabStoryboard().instantiateViewController(withIdentifier: "profilePicView") as! ProfilePicView
    
     let pageControl = UIPageControl()
    
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
        
        pageControlDelegate?.PageViewController(PageViewController: self, didUpdatePageCount: pictureViews.count)
        
        if let firstViewController = pictureViews.first {
            
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
   
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
        
        pageControl.currentPage -= 1
    
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
       
        pageControl.currentPage += 1
        
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

extension ProfilePicPageController: UIPageViewControllerDelegate {
    
    private func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if let firstViewController = viewControllers?.first,
            let index = pictureViews.index(of: firstViewController) {
            pageControlDelegate?.PageViewController(PageViewController: self, didUpdatePageIndex: index)
        }
    }
    
}

protocol ProfilePicPageControlDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func PageViewController(PageViewController: ProfilePicPageController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func PageViewController(PageViewController: ProfilePicPageController,
                                    didUpdatePageIndex index: Int)
    
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
    
    
  // pageControlDelegate = self
       
    @IBAction func didSelectPicture(_ sender: Any) {
        
        
        let imageData = UIImageJPEGRepresentation(currentImage!, 1.0)
        
        SwapUser().uploadProfilePicture(withData: imageData!, completion: {_ in
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
        })
        
    }
    
    
}

extension SelectProfilePicViewController: ProfilePicPageControlDelegate {
    
    func PageViewController(PageViewController: ProfilePicPageController,
                            didUpdatePageCount count: Int){
    
        pageControl.numberOfPages = count
    }
    
    func PageViewController(PageViewController: ProfilePicPageController,
                            didUpdatePageIndex index: Int) {
        
        pageControl.currentPage = index
    }
}

