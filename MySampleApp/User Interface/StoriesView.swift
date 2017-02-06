//
//  StoriesView.swift
//  Swap
//
//  Created by David Slakter on 1/31/17.
//
//

import Foundation

class StoriesView: UIViewController {
    
    override func viewDidLoad() {
        
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
    }
}
