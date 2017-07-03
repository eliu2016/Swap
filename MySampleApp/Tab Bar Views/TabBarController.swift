//
//  TabBarController.swift
//  Swap
//
//  Created by David Slakter on 6/20/17.
//   
//  Use this class to reposition the tab bar on the view
//

import Foundation
import UIKit

class TabBarController: UITabBarController{
    
    let kBarHeight = CGFloat(20)
    
    override func viewWillLayoutSubviews() {
    
    var tabFrame = self.tabBar.frame

   // tabFrame.size.height = kBarHeight
    tabFrame.origin.y = tabFrame.origin.y - 0.5
    self.tabBar.frame = tabFrame
    
    }

}
