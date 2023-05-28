//
//  Track.swift
//  ShazamTry
//
//  Created by Muhammad Tafani Rabbani on 16/05/23.
//
import Foundation
import ShazamKit

struct Track:Identifiable{
    var id = UUID().uuidString
    
    var title = ""
    var artist = ""
    var artwork = URL(string: "")
    var genres = [String]()
    var url = URL(string: "")
    
    init(){
        
    }
    
    init(item:SHMatchedMediaItem){
        title = item.title ?? ""
        artist = item.artist ?? ""
        genres = item.genres
        artwork = item.artworkURL
        url = item.videoURL
    }
}
