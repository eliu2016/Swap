//
//  TutorialPageController.swift
//  Swap
//
//  Created by David Slakter on 2/3/17.
//
//

import Foundation

class TutorialPageController: UIPageViewController {
    
    var ViewCotrollers: [UIViewController] = []
    
   override func viewdidLoad(){
    
    self.setViewControllers(ViewCotrollers, direction: .forward, animated: true, completion: nil)
    
    
    }
}
