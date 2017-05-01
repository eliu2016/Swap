//
//  InstagramView.swift
//  Swap
//
//  Created by David Slakter on 4/16/17.
//
//

import Foundation

var instagramUserID: String? = nil

class instagramView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    @IBOutlet var tableView: UITableView!
    
    var instagramImages: [URL] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.isHidden = true
    
        let user = IGUser(id: instagramUserID ?? "")
        
        tableView.separatorStyle = .none
        
        let tapRecognizer = UILongPressGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(instagramView.didTapPhoto(_:)))
        
        
        SwapUser(username: searchedUser).getInformation(completion: { (error, user) in
            
             circularImageNoBorder(photoImageView: self.profilePic)
              self.profilePic.kf.setImage(with: URL(string: (user?._profilePictureUrl)!))
              self.usernameLabel.text = user?._username
        })
        
        
        user.getMedia { (IGMedias) in
            
            print(IGMedias?.count ?? 0)
            
            
            for media in IGMedias!{
                
                if media.type == .photo{
                        
                    self.instagramImages.append(media.content_url!)
                }
               
            }
           
            self.activityView.stopAnimating()
          
        }
 
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramImages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! InstagramPhotoCell;
        
        cell.setPhoto(imageURL: instagramImages[indexPath.item])
        
        return cell
    }
    
    func didTapPhoto(_ recognizer: UILongPressGestureRecognizer){
   
        
    }
    
}
class InstagramPhotoCell: UITableViewCell {

    
    @IBOutlet var IGImageView: UIImageView!
    
    func setPhoto(imageURL: URL){
        IGImageView.kf.setImage(with: imageURL)
    }
}


