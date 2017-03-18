//
//  ContainerViewController.swift
//
//
//  Created by David Slakter on 7/31/16.

//  Copyright © 2016 Swap. All rights reserved.
//

import Foundation


    var refreshControl: UIRefreshControl!


class ContainerViewController: UIViewController, UIScrollViewDelegate, UITabBarControllerDelegate{
    
  
    
     var scrollView: UIScrollView!
     var SwapCenterButton: UIButton!

    
    override func viewDidLoad() {
  
     
        super.viewDidLoad();
        
        print("Container will load")
        
        //initialize refresh control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Header1"))
        refreshControl.addTarget(self, action: #selector(ContainerViewController.refresh), for: .valueChanged)
        
        
        let Storyboard = self.storyboard
        
        // 1) Create the two views used in the swipe container view
        let AVc = Storyboard?.instantiateViewController(withIdentifier: "ProfileView")
        let BVc = Storyboard?.instantiateViewController(withIdentifier: "ScannerView")
        
        
        // 2) Add in each view to the container view hierarchy
        //    Add them in opposite order since the view hieracrhy is a stack

        self.addChildViewController(BVc!);
      
        BVc!.didMove(toParentViewController: self);
        
        self.addChildViewController(AVc!);
      
        AVc!.didMove(toParentViewController: self);
        
        
        scrollView = UIScrollView(frame: view.bounds)
        
        let scrollWidth: CGFloat  =  self.view.frame.width
        let scrollHeight: CGFloat  = 2 * self.view.frame.size.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight);
        
        
        scrollView.addSubview(BVc!.view);
        scrollView.addSubview(AVc!.view);
        
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        // 3) Set up the frames of the view controllers to align
        //    with eachother inside the container view
        var adminFrame :CGRect = AVc!.view.frame;
        adminFrame.origin.y = adminFrame.height;
        BVc!.view.frame = adminFrame;
        
        var BFrame :CGRect = BVc!.view.frame;
        BFrame.origin.y = BFrame.origin.y - 1334;
     //   CVc.view.frame = BFrame;
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.addSubview(refreshControl)
        
        SwapCenterButton = UIButton(frame: CGRect(x: self.view.frame.size.width*0.42, y: self.view.frame.size.height*0.9, width: 62, height: 60))
        
      /*  var menuButtonFrame = SwapCenterButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        SwapCenterButton.frame = menuButtonFrame*/
        
        
      //  SwapCenterButton.layer.cornerRadius = SwapCenterButton.height/2
        
        SwapCenterButton.layer.zPosition = 2
        
        view.addSubview(SwapCenterButton)
        
        SwapCenterButton.setImage(UIImage(named: "SwapButton"), for: .normal)
        SwapCenterButton.addTarget(self, action: #selector(SwapButtonAction(sender:)), for: .touchUpInside)
        // 4) Finally set the size of the scroll view that contains the frames
    
    }

    
    @objc private func SwapButtonAction(sender: UIButton) {
        
        let scrollViewOffset = self.view.frame.height
        
        if scrollView.contentOffset.y != scrollViewOffset{
           
            //show camera
            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height), animated: true)
            print("scroll up")
        }
        else {
            //reset to default position
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        
        SwapCenterButton.alpha =  20 + scrollView.contentOffset.y
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh(){
        
        self.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
}

