//
//  VideoPlayerModel.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-21.
//

import Foundation
import SwiftUI
import AVKit
class VideoPlayerModel: ObservableObject {
    @Published var player = AVPlayer()
    @Published var isPlaying = false
    
 
  
//    private var previewTimer: Timer?
    
    var layer = AVPlayerLayer()
    init() {
        layer.player = self.player
        layer.videoGravity = .resizeAspectFill
        layer.backgroundColor = CGColor.init(red: 169, green: 169, blue: 169, alpha: 1)
        
        let videoSampleItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MOV")!))
        player.replaceCurrentItem(with: videoSampleItem)
    }
    
    func setVideo(videoURL:URL){
        let asset = AVAsset(url: videoURL)
        let video = AVPlayerItem(asset: asset)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.player.replaceCurrentItem(with: video)
    }
    @objc func playerDidFinishPlaying(notification: NSNotification){
        isPlaying = false
    }
    
    func play(){
       
        guard player.currentItem != nil else {
            return //error handling for no item in player?
        }
        
        if isPlaying {
            player.pause()
            isPlaying = false
            return
        }
        
        if player.currentItem!.currentTime() == player.currentItem!.duration{
            player.currentItem!.seek(to: .zero, completionHandler: nil)
        }
        isPlaying = true
        player.play()
        
    
        
        
    }

}
