//
//  TabBarController.swift
//  Swap
//
//  Created by David Slakter on 6/20/17.
//
//

import Foundation
import UIKit

class TabBarController: UITabBarController{
    
    let kBarHeight = CGFloat(15)
    
    override func viewWillLayoutSubviews() {
    
    var tabFrame = self.tabBar.frame

    tabFrame.size.height = kBarHeight
    tabFrame.origin.y = self.view.frame.size.height - kBarHeight - 1
    self.tabBar.frame = tabFrame
    
    }

}
