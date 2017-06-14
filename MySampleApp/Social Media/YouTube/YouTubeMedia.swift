//
//  YouTubeMedia.swift
//  Swap
//
//  Created by Micheal S. Bingham on 2/7/17.
//
//

import Foundation
import SwiftyJSON

class YouTubeMedia {
    
    var videoID: String = ""
    var datePublished: Date = Date()
    var channelID: String = ""
    var title: String = ""
    var description: String = ""
    var defaultThumbnail: String = ""
    var highResThumbnail: String = ""
    var channelTitle: String = ""
    var linkToYouTubeVideo: String = ""
    
    var webview: UIWebView?
    
    init(youtubeMediaJSON: JSON) {
        
        // create youtube object from JSON
        
        
        self.videoID = youtubeMediaJSON["id"]["videoId"].string ?? ""
        self.datePublished = (youtubeMediaJSON["snippet"]["publishedAt"].string ?? "2015-01-01T00:00:00.000Z").dateFromISO8601!
        self.channelID = youtubeMediaJSON["snippet"]["channelId"].string ?? ""
        self.title = youtubeMediaJSON["snippet"]["title"].string ?? ""
        self.description = youtubeMediaJSON["snippet"]["description"].string ?? ""
        self.defaultThumbnail = youtubeMediaJSON["snippet"]["thumbnails"]["default"]["url"].string ?? ""
        self.highResThumbnail = youtubeMediaJSON["snippet"]["thumbnails"]["high"]["url"].string ?? ""
        self.channelTitle = youtubeMediaJSON["snippet"]["channelTitle"].string ?? ""
        self.linkToYouTubeVideo = "https://youtube.com/watch?v=\(self.videoID)"
    
    }
    
}

extension JSON{
    
    func toYouTubeMedias() -> [YouTubeMedia] {
        
        var medias: [YouTubeMedia] = []
        let jsonResponse = self
        
        guard jsonResponse["items"].array != nil else {
            
            return []
        }
        
        let arrayOfJSONs = jsonResponse["items"].array!
        
        for json in arrayOfJSONs{
            
            
            let media = YouTubeMedia(youtubeMediaJSON: json)
            medias.append(media)
        }
        
        return medias
    }
    
}


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    static let dateShortFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
    }()
    
    
    var stringValueShort: String {
        return Date.dateShortFormatter.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
