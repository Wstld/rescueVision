//
//  VideoPlayerModel.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-21.
//

import Foundation
import SwiftUI
import AVKit
import Combine

class VideoPlayerModel: ObservableObject {
    @Published var player = AVPlayer()
    @Published var isPlaying = false
    @Published var loading = false
    private var itemObservation:AnyCancellable?
    
    var layer = AVPlayerLayer()
    
    init() {
        layer.player = self.player
        layer.videoGravity = .resizeAspectFill
        layer.backgroundColor = CGColor.init(red: 169, green: 169, blue: 169, alpha: 1)
    }
    
    func setVideo(videoURL:String){
        //reset observer.
        loading = true
        itemObservation = nil
        
        let urlSet = URL(string: videoURL)!
        let asset = AVAsset(url: urlSet)
        let video = AVPlayerItem(asset: asset)
        
        //observe change in player item status.
        itemObservation = video.publisher(for: \.status).sink{
            newstatus in
            if newstatus == .readyToPlay{
                self.loading = false
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.player.replaceCurrentItem(with: video)
    }
    @objc func playerDidFinishPlaying(notification: NSNotification){
        isPlaying = false
    }
    
    func play(){
        
        guard player.currentItem != nil else {
            return
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
