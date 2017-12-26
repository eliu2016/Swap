//
//  TutorialPageController.swift
//  Swap
//
//  Created by David Slakter on 2/3/17.
//
//

import Foundation

class TutorialPageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var tutorialViews = [UIViewController]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var Tstoryboard: UIStoryboard! = nil
        Tstoryboard = UIStoryboard(name: "Tutorial_Main", bundle: nil)
    
        let tpage1 = Tstoryboard.instantiateViewController(withIdentifier: "tpage1")
        let tpage2 = Tstoryboard.instantiateViewController(withIdentifier: "tpage2")
        let tpage3 = Tstoryboard.instantiateViewController(withIdentifier: "tpage3")
        let tpage4 = Tstoryboard.instantiateViewController(withIdentifier: "tpage4")
        let tpage5 = Tstoryboard.instantiateViewController(withIdentifier: "tpage5")
        let tpage6 = Tstoryboard.instantiateViewController(withIdentifier: "tpage6")
        let tpage7 = Tstoryboard.instantiateViewController(withIdentifier: "tpage7")
        let tpage8 = Tstoryboard.instantiateViewController(withIdentifier: "tpage8")
        let tpage9 = Tstoryboard.instantiateViewController(withIdentifier: "tpage9")
        let tpage10 = Tstoryboard.instantiateViewController(withIdentifier: "tpage10")
        
        tutorialViews = [tpage1, tpage2, tpage3, tpage4, tpage5, tpage6, tpage7, tpage8, tpage9, tpage10]
        
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
