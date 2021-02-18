//
//  VidTest.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-21.
//

import Foundation
import SwiftUI
import AVKit
struct VidTest: UIViewRepresentable {
  
    typealias UIViewType = VideoPlayer
    
    func makeUIView(context: Context) -> VideoPlayer {
        
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "MOV")!)
        let player = AVPlayer(url: path)
        
        let layer = AVPlayerLayer()
        layer.videoGravity = .resizeAspectFill
        layer.player = player
        
        let view = VideoPlayer(player:player)
        

        
        
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        return
    }
}
