//
//  YoutubeView.swift
//  Swap
//
//  Created by David Slakter on 4/27/17.
//
//

import Foundation


var YouTubeUserID: String? = nil

class YoutubeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var youtubeVideos: [YouTubeMedia] = []
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        let user = YouTubeUser(id:  YouTubeUserID ?? "")
        tableView.separatorStyle = .none
        self.automaticallyAdjustsScrollViewInsets = true
        
        user.getMedia { (YoutubeMedias) in
            
            print(YoutubeMedias?.count ?? 0)
            
            for media in YoutubeMedias!{
                
                self.youtubeVideos.append(media)
                
            }
            
            if self.youtubeVideos.count == 0{
                
                let blankTableMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                
                blankTableMessage.text = "No Youtube Videos"
                blankTableMessage.textColor = .black
                blankTableMessage.textAlignment = NSTextAlignment.center
                blankTableMessage.font = UIFont(name: "Avenir-Next", size: 20)
                blankTableMessage.sizeToFit()
                
                self.tableView.backgroundView = blankTableMessage
                self.view.backgroundColor = UIColor.white
            }
            else{
                self.view.backgroundColor = UIColor(hex: "#272931")
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeVideos.count-1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! YouTubeVideoCell;

        cell.selectionStyle = .none
        
        let currentVideo = youtubeVideos[indexPath.row]
        
      
        cell.setVideo(videoURL: "https://www.youtube.com/embed/\(currentVideo.videoID)")
        
        cell.channelName.text = currentVideo.channelTitle

        cell.datePosted.text = currentVideo.datePublished.stringValueShort
        
        SwapUser(username: searchedUser).getInformation(completion: { (error, user) in
            
           cell.setProfilePicture(imageURL: URL(string: (user?._profilePictureUrl)!)!)
            
        })
        
        return cell
    }
    
}

class YouTubeVideoCell: UITableViewCell {
    
    @IBOutlet var videoView: UIWebView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var channelName: UILabel!
    @IBOutlet var datePosted: UILabel!
    
    func setVideo(videoURL: String){
        
        
        videoView.scrollView.contentInset = UIEdgeInsets.zero
        
        
        videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(videoURL)?&playsinline=0\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
        videoView.allowsInlineMediaPlayback = false
        videoView.scrollView.isScrollEnabled = false
        
    }
   
    func setProfilePicture(imageURL: URL){
        
        profilePicture.contentMode = .scaleAspectFit
        profilePicture.kf.setImage(with: imageURL)
    }
    
}
