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
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePageControl), name: .updatePageControl, object: nil)
        
        if UserDefaults.standard.bool(forKey: "didShowTutorial"){
            
            closeButton.isHidden = false
            
        }
        else{
            
            closeButton.isHidden = true
            UserDefaults.standard.set(true, forKey: "didShowTutorial")
        }
    }
    @IBAction func closeTutorial(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatePageControl(){
        pageControl.currentPage = tutorialCurrentIndex
    }
    
}
