//
//  VideoUIView.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-22.
//

import Foundation
import AVKit
import SwiftUI

class VideoUIView: UIView {
    private var videoPlayer:VideoPlayerModel
    
    init(frame:CGRect,videoPlayer:VideoPlayerModel) {
        self.videoPlayer = videoPlayer
        super.init(frame: frame)
        layer.addSublayer(videoPlayer.layer)
    }
    
    required init?(coder: NSCoder) {
        self.videoPlayer = VideoPlayerModel()
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer.layer.frame = bounds
    }
}
