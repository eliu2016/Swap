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
    
    override func viewDidAppear(_ animated: Bool) {
        
        let user = YouTubeUser(id:  YouTubeUserID ?? "")
        youtubeVideos = []
        tableView.separatorStyle = .none
        
        user.getMedia { (YoutubeMedias) in
            
            print(YoutubeMedias?.count ?? 0)
            
            
            for media in YoutubeMedias!{
                
                self.youtubeVideos.append(media)
                
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeVideos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! YouTubeVideoCell;

        cell.selectionStyle = .none
        
        let currentVideo = youtubeVideos[indexPath.row]
      
        cell.setVideo(videoURL: currentVideo.linkToYouTubeVideo)
        
        cell.channelName.text = currentVideo.channelTitle
        
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
        
        videoView.scrollView.isScrollEnabled = false
        self.videoView.allowsInlineMediaPlayback = true
        self.videoView.mediaPlaybackRequiresUserAction = false
        
        videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(videoURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
    }
    
    func setProfilePicture(imageURL: URL){
        
        profilePicture.kf.setImage(with: imageURL)
    }
    
}
