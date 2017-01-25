//
//  notificationView.swift
//  Swap
//
//  Created by David Slakter on 1/21/17.
//
//

import Foundation

class notificationView: UIViewController {
    
    override func viewDidLoad() {
        self.setupSwipeGestureRecognizers(allowCyclingThoughTabs: true)
    }
}
