//
//  ContainerViewController.swift
//
//
//  Created by David Slakter on 7/31/16.

//  Copyright © 2016 Swap. All rights reserved.
//

import Foundation


    var refreshControl: UIRefreshControl!
    var isRefreshing = false

class ContainerViewController: UIViewController, UIScrollViewDelegate, UITabBarControllerDelegate{
    
    
     var scrollView: UIScrollView!
     var SwapCenterButton: UIButton!
     var lastContentOffset: CGFloat!
    
    override func viewDidLoad() {
     SC
        super.viewDidLoad();
        print("Container will load")
    
        
        
        //initialize refresh control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.isHidden = true
        refreshControl.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Header1"))
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Header1"))
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
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
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
        
        SwapCenterButton = UIButton(frame: getSwapButtonFrame())
        
      /*  var menuButtonFrame = SwapCenterButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        SwapCenterButton.frame = menuButtonFrame*/
        
        
      //  SwapCenterButton.layer.cornerRadius = SwapCenterButton.height/2
        SwapCenterButton.layer.zPosition = 2
        
        view.addSubview(SwapCenterButton)
        
        SwapCenterButton.setImage(UIImage(named: "SwapButton"), for: .normal)
        SwapCenterButton.addTarget(self, action: #selector(SwapButtonAction(sender:)), for: .touchUpInside)
        
        
        //notification listens when to disable reloading
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableReloading), name: .disableReloading, object: nil)
   
    
    }
    func getSwapButtonFrame() -> CGRect{
        
        var buttonRect: CGRect?
        
        switch(self.storyboard?.value(forKey: "name") as! String){
            
            case "Main":
                buttonRect = CGRect(x: self.view.frame.size.width*0.42, y: self.view.frame.size.height*0.9, width: 62, height: 60)
                break
            case "IPhone7Plus":
                buttonRect = CGRect(x: 177, y: 665, width: 65, height: 65)
                break
            case "IPhoneSE":
                buttonRect = CGRect(x: 134, y: 510, width: 56, height: 55)
                break
            case "IPhoneX":
                buttonRect = CGRect(x: 157, y: 700, width: 65, height: 65)
                break
            case "IPad":
                   buttonRect = CGRect(x: 135, y: 422, width: 51, height: 50)
            break
            default:
                 buttonRect = CGRect(x: self.view.frame.size.width*0.42, y: self.view.frame.size.height*0.9, width: 62, height: 60)
                break
            
            
        }
        return buttonRect!
    }

    
    @objc private func SwapButtonAction(sender: UIButton) {
        
        let scrollViewOffset = self.view.frame.height
        
        if scrollView.contentOffset.y != scrollViewOffset{
           
            //show camera
            NotificationCenter.default.post(name: .didShowScanner, object: nil)
            scanner.startScan()
            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.frame.height), animated: true)
            
            
        }
        else {
            //reset to default position
            scanner.stopScan()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.lastContentOffset = scrollView.contentOffset.y;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        guard self.lastContentOffset != nil else {
            
            return
        }
        
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            
           // print("On scanner")
           NotificationCenter.default.post(name: .didShowScanner, object: nil)
           scanner.startScan()
            
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            
           //print("On Profile")
            //Stop Scanner 
            scanner.stopScan()
            
            
        } else {
            // didn't move
            
            
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        
        SwapCenterButton.alpha =  1 + (0.2*scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y > 100{
            
            scrollView.bounces = false
        }
        else{
            scrollView.bounces = true
        }
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh(){
        
        animateRefresh()
        postNotificationToReloadScreens()

    }
    
    func animateRefresh(){
        
       
        /*let color1 = UIColor(red: 58/255.0, green: 1/255.0, blue: 65/255.0, alpha: 1.0)
        let color2 = UIColor(red: 125/255.0, green: 1/255.0, blue: 65/255.0, alpha: 1.0)
        let color3 = UIColor(red: 125/255.0, green: 130/255.0, blue: 65/255.0, alpha: 1.0)
        let color4 = UIColor(red: 125/255.0, green: 130/255.0, blue: 137/255.0, alpha: 1.0)
        let color5 = UIColor(red: 125/255.0, green: 130/255.0, blue: 230/255.0, alpha: 1.0)
        let color6 = UIColor(red: 125/255.0, green: 220/255.0, blue: 230/255.0, alpha: 1.0)
        
        var colorArray = [color1, color2, color3, color4, color5, color6]
        
        
        struct ColorIndex{
            static var colorIndex = 0
        }
        
        
        UIView.animate(withDuration: 1, animations: {
            
            refreshControl.backgroundColor = colorArray[ColorIndex.colorIndex]
             self.view.backgroundColor = colorArray[ColorIndex.colorIndex]
            ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            
            
        }) { finished in
            
            if (refreshControl.isRefreshing){
                self.animateRefresh()
            }
            else{
                  refreshControl.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Header1"))
                  self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Header1"))
            }
        
        }*/
        
    }
    
    func postNotificationToReloadScreens()  {
        
        if let screen = getLastScreen(){
            print("\nthe screen is .. \(screen)")
            switch screen {
            case .UserProfileScreen:
                NotificationCenter.default.post(name: .reloadProfile, object: nil)
            case .NotificationsScreen:
                NotificationCenter.default.post(name: .reloadNotifications, object: nil)
            case .SearchedUserProfileScreen:
                //NotificationCenter.default.post(name: .reloadSearchedUserProfile, object: nil)
                // Will add notification later, pull to refresh isn't enabled on SeaarchedUserProfile yet
                refreshControl.endRefreshing()
            case .SwappedScreen:
                NotificationCenter.default.post(name: .reloadSwapped, object: nil)
            case .SwapsScreen:
                NotificationCenter.default.post(name: .reloadSwaps, object: nil)
                
            default:
                break
            }
        } else{
            
            refreshControl.endRefreshing()
        }
    }
    
    func disableReloading(){
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
    }
    func enableReloading(){
        scrollView.alwaysBounceVertical = true
    }
    
}

