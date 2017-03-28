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
        
    
        SwapUser().getInformation { (error, user) in
            
            DispatchQueue.main.async {
                
                if let user = user{
                
                    let isPrivate  = user._isPrivate as? Bool ?? false
                
                    self.privateAccountSwitch.isOn = isPrivate
                
                }
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        for indexpath in self.tableView.indexPathsForVisibleRows!{
            
            self.tableView.deselectRow(at: indexpath, animated: true)
            
        }

        
    }
    @IBAction func closeSettings(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .reloadProfile, object: nil)
        
    }
    
    @IBAction func didTogglePrivateAccount(_ sender: UISwitch) {
        
            
      SwapUser().set(isPrivate: sender.isOn)
            
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
                self.view.addSubview(loadingOverlay.showLoadingSymbol(view: self.view))
                
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
