//
//  TutorialPageController.swift
//  Swap
//
//  Created by David Slakter on 2/3/17.
//
//

import Foundation

class TutorialPageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var tpage1 = grabStoryboard().instantiateViewController(withIdentifier: "tpage1")
    var tpage2 = grabStoryboard().instantiateViewController(withIdentifier: "tpage2")
    var tpage3 = grabStoryboard().instantiateViewController(withIdentifier: "tpage3")
    var tpage4 = grabStoryboard().instantiateViewController(withIdentifier: "tpage4")
     var tpage5 = grabStoryboard().instantiateViewController(withIdentifier: "tpage5")
     var tpage6 = grabStoryboard().instantiateViewController(withIdentifier: "tpage6")
     var tpage7 = grabStoryboard().instantiateViewController(withIdentifier: "tpage7")
    var tpage8 = grabStoryboard().instantiateViewController(withIdentifier: "tpage8")
    var tpage9 = grabStoryboard().instantiateViewController(withIdentifier: "tpage9")
    var tpage10 = grabStoryboard().instantiateViewController(withIdentifier: "tpage10")
    var tpage11 = grabStoryboard().instantiateViewController(withIdentifier: "tpage11")
    
    
    var tutorialViews = [UIViewController]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tutorialViews = [tpage1, tpage2, tpage3, tpage4, tpage5, tpage6, tpage7, tpage8, tpage9, tpage10, tpage11]
        
        dataSource = self
        delegate = self
        
        //set the first controller in the pageViewController
        if let firstViewController = tutorialViews.first {
            
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    /*Delegate function*/
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //only execute if the transition from one page to the next is completed
        if completed{
            
            //update the current index and the page Control
           
            tutorialCurrentIndex = tutorialViews.index(of: (viewControllers?.first)!)!
            NotificationCenter.default.post(name: .updatePageControl, object: nil)
        }
    }
    
    /*Data Source Function*/
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = tutorialViews.index(of: viewController) else {
            
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            
            return nil
        }
        
        guard tutorialViews.count > previousIndex else {
            
            return nil
        }
        
        
        return tutorialViews[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        guard let viewControllerIndex = tutorialViews.index(of: viewController) else {
            
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let pictureViewsCount = tutorialViews.count
        
        guard pictureViewsCount != nextIndex else{
            
            return nil
        }
        
        guard pictureViewsCount > nextIndex else{
            return nil
        }
        
        return tutorialViews[nextIndex]
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    


}
