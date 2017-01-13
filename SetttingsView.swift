//
//  Setttings.swift
//  Swap
//
//  Created by David Slakter on 12/20/16.
//
//

import Foundation

class SettingsView: UITableViewController {
    
    override func viewDidLoad() {
        
    }
    @IBAction func closeSettings(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //code that runs when a certain row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
       //clear swap history row pressed
        if (indexPath.section == 1 && indexPath.row == 2){
            
            let alert = UIAlertController(title: "Erase Swap History?", message: "This action cannot be undone", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let OkAction = UIAlertAction(title: "Yes", style: .default){ (action) in
                
                //call a method that clears the swap history
                }
            
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //log out row pressed
        if (indexPath.section == 1 && indexPath.row == 3){
            
            let alert = UIAlertController(title: "Confirm Sign Out?", message: "Swap Points will reset", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Canvel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default){ (action) in
                
               
                let loadingOverlay = ShowLoadingOverlay()
                
                self.view.addSubview(loadingOverlay.showBlackOverlay())
                self.view.addSubview(loadingOverlay.showLoadingSymbol())
                
                signOut{
                    DispatchQueue.main.async {
                        // Successfully Sign out
                        logoutSocialMediasAndClearCookies()
                        self.performSegue(withIdentifier: "signOut", sender: nil)
                    }
                }
                
          })
            self.present(alert, animated: true, completion: nil)
            
       }
        
    }
}
