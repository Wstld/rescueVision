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
    var videoURL:URL?
    
    func makeUIView(context: Context) ->  UIView {
        if let video = videoURL {
        videoPlayer.setVideo(videoURL:video)
        }
        
        let view = VideoUIView(frame: .zero, videoPlayer: videoPlayer)
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
