//
//  SwapsViewController.swift
//  Swap
//
//  Created by David Slakter on 1/14/17.
//
//

import Foundation

class SwapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    var swapHistoryUsers: [SwapHistory] = []
    var sharedSocialMedias: [UIImage] = []
    
    override func viewDidLoad() {
        
        save(screen: .SwapsScreen)
        loadSwaps()
        
        // Listens for reloadSwaps notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSwaps), name: .reloadSwaps, object: nil)
        
    }
    
   
    
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swapHistoryUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "swapsCell", for: indexPath) as! swapsTableCell;
        
         cell.selectionStyle = .none
        cell.profilePicture.kf.indicatorType = .activity
        let user = swapHistoryUsers[indexPath.item]
        
        sharedSocialMedias = getSharedSocialMedias(currentUser: user)
        
        if sharedSocialMedias.indices.contains(0){
            cell.socialMedia1.image = sharedSocialMedias[0]
        }
        else{
            cell.socialMedia1.image = nil
        }
        if sharedSocialMedias.indices.contains(1){
            cell.socialMedia2.image = sharedSocialMedias[1]
        }
        else{
            cell.socialMedia2.image = nil
        }
        if sharedSocialMedias.indices.contains(2){
            cell.socialMedia3.image = sharedSocialMedias[2]
        }
        else{
            cell.socialMedia3.image = nil
        }
        if sharedSocialMedias.indices.contains(3){
            cell.socialMedia4.image = sharedSocialMedias[3]
        }
        else{
            cell.socialMedia4.image = nil
        }
        if sharedSocialMedias.indices.contains(4){
            cell.socialMedia5.image = sharedSocialMedias[4]
        }
        else{
            cell.socialMedia5.image = nil
        }
        if sharedSocialMedias.indices.contains(5){
            cell.socialMedia6.image = sharedSocialMedias[5]
        }
        else{
            cell.socialMedia6.image = nil
        }
        if sharedSocialMedias.indices.contains(6){
            cell.socialMedia7.image = sharedSocialMedias[6]
        }
        else{
            cell.socialMedia7.image = nil
        }
        if sharedSocialMedias.indices.contains(7)
        {
            cell.socialMedia8.image = sharedSocialMedias[7]
        }
        else{
            cell.socialMedia8.image = nil
        }
        if sharedSocialMedias.indices.contains(8)
        {
            cell.socialMedia9.image = sharedSocialMedias[8]
        }
        else{
            cell.socialMedia9.image = nil
        }
        if sharedSocialMedias.indices.contains(9){
            cell.socialMedia10.image = sharedSocialMedias[9]
        }
        else{
            cell.socialMedia10.image = nil
        }
        
       cell.swapDate.text = user._time?.timeAgo()
        
        SwapUser(username: user._swapped!).getInformation(completion: {(error, user) in
            
            cell.profilePicture.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
            circularImage(photoImageView: cell.profilePicture)
            
            DispatchQueue.main.async {
                
            
                cell.username.text = (user?._firstname)! + " " + (user?._lastname)!
                
            }
            
        })

        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchedUser = swapHistoryUsers[indexPath.item]._swapped!
        
        self.performSegue(withIdentifier: "ShowSwapsUserProfile", sender: nil)
    }
    func getSharedSocialMedias(currentUser: SwapHistory) -> [UIImage]{
        
        var images: [UIImage] = []
        
        if (currentUser._didShareInstagram as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "InstagramBlackIcon"))
        }
        if (currentUser._didShareTwitter as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "TwitterBlackIcon"))
        }
        if (currentUser._didShareSpotify as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "SpotifyBlackIcon"))
        }
        if (currentUser._didShareEmail as? Bool) ?? false || (currentUser._didSharePhonenumber as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "ProfileBlackIcon"))
        }
        if (currentUser._didShareSoundCloud as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "SoundCloudBlackIcon"))
        }
        if (currentUser._didSharePinterest as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "PinterestBlackIcon"))
        }
        if (currentUser._didShareGitHub as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "GithubBlackIcon"))
        }
        if (currentUser._didShareReddit as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "RedditBlackIcon"))
        }
        if (currentUser._didShareYouTube as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "YouTubeBlackIcon"))
        }
        if (currentUser._didShareVimeo as? Bool) ?? false{
            images.append(#imageLiteral(resourceName: "VimeoBlackIcon"))
        }
        return images
    }
    
    
    
    func loadSwaps()  {
        
        SwapUser().getSwapHistory { (error, swapHistory) in
            
            if error != nil{
                
                print("error retriving swap history")
                refreshControl.endRefreshing()
            }
            else{
                
                DispatchQueue.main.async {
                    
                    self.activityView.isHidden = true
                    self.swapHistoryUsers = swapHistory!
                    refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        
    }
}

class swapsTableCell: UITableViewCell {
    
    @IBOutlet var socialMedia1: UIImageView!
    @IBOutlet var socialMedia2: UIImageView!
    @IBOutlet var socialMedia3: UIImageView!
    @IBOutlet var socialMedia4: UIImageView!
    @IBOutlet var socialMedia5: UIImageView!
    @IBOutlet var socialMedia6: UIImageView!
    @IBOutlet var socialMedia7: UIImageView!
    @IBOutlet var socialMedia8: UIImageView!
    @IBOutlet var socialMedia9: UIImageView!
    @IBOutlet var socialMedia10: UIImageView!
    
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var swapDate: UILabel!
    @IBOutlet var username: UILabel!
}
