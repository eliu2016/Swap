//
//  InstagramView.swift
//  Swap
//
//  Created by David Slakter on 4/16/17.
//
//

import Foundation

var instagramUserID: String? = nil
var instagramPreviewUser: Users? = nil

class instagramView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var activityView: UIActivityIndicatorView!

    
    @IBOutlet var tableView: UITableView!
    
    var instagramImages: [IGMedia] = []
    var videoIndexes: [Int] = []
    
    override func viewDidLoad() {
        
        loadInstagramPreview()
    }
    
    func loadInstagramPreview()  {
        
        instagramImages = []
        
        tableView.isHidden = true
        
        let user = IGUser(id: instagramUserID ?? "")
        
        tableView.separatorStyle = .none
        
        let tapRecognizer = UILongPressGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(instagramView.didTapPhoto(_:)))
        
        
        user.getMedia { (IGMedias) in
            
            print(IGMedias?.count ?? 0)
            
            
            var index = 0;
            
            for media in IGMedias!{
                
                
                if media.type == .photo{
                    
                    self.instagramImages.append(media)
                }
                else if media.type == .video{
                    self.instagramImages.append(media)
                    self.videoIndexes.append(index)
                }
                index += 1;
            }
            
            if self.instagramImages.count == 0{
                
                let blankTableMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                
                blankTableMessage.text = "No Instagram Posts"
                blankTableMessage.textColor = .black
                blankTableMessage.textAlignment = NSTextAlignment.center
                blankTableMessage.font = UIFont(name: "Avenir-Next", size: 20)
                blankTableMessage.sizeToFit()
                
                self.tableView.backgroundView = blankTableMessage
                self.view.backgroundColor = UIColor.white
                
            }
            
            self.activityView.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramImages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! InstagramPhotoCell;
        
        cell.selectionStyle = .none
        
        let currentImage = instagramImages[indexPath.row]
        
        cell.likeButton.tag = indexPath.row
        
        if currentImage.isLiked {
            
            cell.likeButton.setImage(#imageLiteral(resourceName: "FilledHeart"), for: .normal)
        }
        else{
            cell.likeButton.setImage(#imageLiteral(resourceName: "UnfilledHeart"), for: .normal)
        }
        
        circularImageNoBorder(photoImageView: cell.profilePic)
        cell.profilePic.kf.setImage(with: URL(string: (instagramPreviewUser?._profilePictureUrl)!))
        cell.username.text = instagramPreviewUser?._username
        
      
        
        if isVideo(media: currentImage, mediaIndex: indexPath.row){
            
            //set a thumbnail to represent the instagram video
            cell.setPhoto(imageURL: currentImage.content_url!)
        }
        else {
        
            cell.setPhoto(imageURL: currentImage.content_url!)
        }
        
        return cell
    }
    
    func isVideo(media: IGMedia, mediaIndex: Int) -> Bool{
        
        for index in videoIndexes{
            
            if index == mediaIndex{
                return true
            }
        }
        
        return false
        
    }
    
    func didTapPhoto(_ recognizer: UILongPressGestureRecognizer){
   
        
    }
    @IBAction func didTapLike(_ sender: Any) {
        
        let likedImage = instagramImages[(sender as AnyObject).tag]
        
        likedImage.like { (error) in
            
            if error != nil {
                print("error liking picture")
            }
            else{
                (sender as! UIButton).setImage(#imageLiteral(resourceName: "FilledHeart"), for: .normal)
            }
        }
        
        
    }
    
}
class InstagramPhotoCell: UITableViewCell {

    
    @IBOutlet var username: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var IGImageView: UIImageView!
    
    @IBOutlet var likeButton: UIButton!

    func setPhoto(imageURL: URL){
        IGImageView.kf.setImage(with: imageURL)
    }
}


