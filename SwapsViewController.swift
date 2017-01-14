//
//  SwapsViewController.swift
//  Swap
//
//  Created by David Slakter on 1/14/17.
//
//

import Foundation

class SwapsViewController: UIViewController, UITableViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        SwapUser().getSwapHistory { (error, swapHistory) in
            
            if error != nil{
                
            }
            else{
                
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
}
