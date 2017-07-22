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
    @IBOutlet var SwapCodeColorIndicator: UIImageView!
    
    var SwapCodeColorBlue: Bool?
    
    override func viewDidLoad() {
        
        SwapUser().getInformation { (error, user) in
            
            DispatchQueue.main.async {
                
                if let user = user{
                    
                    let isPrivate  = user._isPrivate as? Bool ?? false
                    
                    self.privateAccountSwitch.isOn = isPrivate
                    
                }
                
            }
        }
        
        
        SwapCodeColorBlue = UserDefaults.standard.bool(forKey: "SwapCodeColorBlue") ?? false
        
        if SwapCodeColorBlue!{
            SwapCodeColorIndicator.image = #imageLiteral(resourceName: "SwapCodeColor2")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    
        // Moved this code to ViewDidLoad - Micheal Bingham
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        for indexpath in self.tableView.indexPathsForVisibleRows!{
            
            self.tableView.deselectRow(at: indexpath, animated: true)
            
        }

        
    }
    @IBAction func closeSettings(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func didTogglePrivateAccount(_ sender: UISwitch) {
        
            
      SwapUser().set(isPrivate: sender.isOn)
            
    }
    
    //code that runs when a certain row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //change swap code row pressed
        if (indexPath.section == 0 && indexPath.row == 1){
            
            SwapCodeColorBlue = !SwapCodeColorBlue!
            
            if (SwapCodeColorBlue == false){
                
                SwapCodeColorIndicator.image = #imageLiteral(resourceName: "SwapCodeColor1")
                
                UserDefaults.standard.set(false, forKey: "SwapCodeColorBlue")
                UserDefaults.standard.synchronize()
                
                // Send Notification That Swap Color Changed
                NotificationCenter.default.post(name: .changeSwapCodeToDark, object: nil)
                
            }
            else{
                SwapCodeColorIndicator.image = #imageLiteral(resourceName: "SwapCodeColor2")
                
                UserDefaults.standard.set(true, forKey: "SwapCodeColorBlue")
                UserDefaults.standard.synchronize()
                
                // Send Notification That Swap Color Changed 
                NotificationCenter.default.post(name: .changeSwapCodeToBlue, object: nil)
            }
        }
     
        
        //log out row pressed
        if (indexPath.section == 1 && indexPath.row == 3){
            
            let alert = UIAlertController(title: "Are You Sure?", message: "Your swap points will reset and you will have to reconnect your social medias if you sign out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
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
