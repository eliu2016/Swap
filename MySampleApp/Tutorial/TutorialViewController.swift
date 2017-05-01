//
//  TutorialViewController.swift
//  Swap
//
//  Created by David Slakter on 4/29/17.
//
//

import Foundation

var tutorialCurrentIndex = 0

class TutorialViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePageControl), name: .updatePageControl, object: nil)
    }
    
    func updatePageControl(){
        pageControl.currentPage = tutorialCurrentIndex
    }
    
}
