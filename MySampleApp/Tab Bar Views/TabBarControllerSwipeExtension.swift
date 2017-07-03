    //
//  TabBarControllerSwipeExtension.swift
//  SwipeTabBar-Swift
//
//  Created by Cezar Carvalho Pereira on 23/1/15.
//  Copyright (c) 2015 Wavebits. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupSwipeGestureRecognizers(allowCyclingThoughTabs cycleThroughTabs: Bool = false) {
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: cycleThroughTabs ? #selector(handleSwipeLeftAllowingCyclingThroughTabs) : #selector(handleSwipeLeft))
        swipeLeftGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: cycleThroughTabs ? #selector(handleSwipeRightAllowingCyclingThroughTabs) : #selector(handleSwipeRight))
        swipeRightGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeRightGestureRecognizer)
      
    }
    
    @objc private func handleSwipeLeft(swipe: UISwipeGestureRecognizer) {
       tabBarController?.selectedIndex += 1

    }
    
    @objc private func handleSwipeRight(swipe: UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex -= 1
    }
    
    @objc private func handleSwipeLeftAllowingCyclingThroughTabs(swipe: UISwipeGestureRecognizer) {
      
        let maxIndex = (tabBarController?.viewControllers?.count)
        let nextIndex = (tabBarController?.selectedIndex)! + 1
        tabBarController?.selectedIndex = nextIndex < maxIndex! ? nextIndex : 0
        
    }
    
    @objc private func handleSwipeRightAllowingCyclingThroughTabs(swipe: UISwipeGestureRecognizer) {
        
        let maxIndex = (tabBarController?.viewControllers?.count)
        let nextIndex = (tabBarController?.selectedIndex)! - 1
        tabBarController?.selectedIndex = nextIndex >= 0 ? nextIndex : maxIndex! - 1
        
    }
}
