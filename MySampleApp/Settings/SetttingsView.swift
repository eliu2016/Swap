//
//  Setttings.swift
//  Swap
//
//  Created by David Slakter on 12/20/16.
//
//

import Foundation

class SettingsView: UITableViewController {
    
    @IBOutlet var privateAccountSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        
        SwapUser().getInformation(completion: { (error, user) in
            
    
            //needs modification
            if (user?._isPrivate == 1){
                self.privateAccountSwitch.isOn = true
            }
            else{
                self.privateAccountSwitch.isOn = false
            }
        
        })
        
    }
    @IBAction func closeSettings(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func didTogglePrivateAccount(_ sender: UISwitch) {
        
            
        if sender.isOn{
            SwapUser().set(isPrivate: true)
        }
        else{
            SwapUser().set(isPrivate: false)
        }
            
    }
    
    //code that runs when a certain row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        //log out row pressed
        if (indexPath.section == 1 && indexPath.row == 2){
            
            let alert = UIAlertController(title: "Confirm Sign Out?", message: "Swap Points will reset", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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
