//
//  PlayVideo.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-21.
//

import Foundation
import SwiftUI
import AVKit

struct VideoPreview:UIViewRepresentable {
    @ObservedObject var videoPlayer: VideoPlayerModel
    var videoURL:String
    
    func makeUIView(context: Context) ->  UIView {
    
        videoPlayer.setVideo(videoURL:videoURL)
        
        
        let view = VideoUIView(frame: .zero, videoPlayer: videoPlayer)
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
