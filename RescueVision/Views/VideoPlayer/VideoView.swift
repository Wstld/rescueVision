//
//  VideoPlayer.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-21.
//

import SwiftUI

struct VideoView: View {
    @StateObject var videoPlayer = VideoPlayerModel()
    
    var videoURL:String
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                ZStack{
                    //show video
                    VideoPreview(videoPlayer: videoPlayer,videoURL: videoURL)
                        .onTapGesture {
                            videoPlayer.play()
                        }
                    //show play btn.
                    if videoPlayer.isPlaying == false && videoPlayer.loading == false {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .opacity(0.7)
                        .frame(width:geo.size.width/2 , height: geo.size.width/2, alignment:.center)
                        .position(x: geo.size.width/2, y: geo.size.height/2)
                        .onTapGesture {
                            videoPlayer.play()
                        }
                    }
                    //show loading.
                    if videoPlayer.isPlaying == false && videoPlayer.loading == true{
                        ActivitySpinner()
                    }
                }
            }
        }
        
    }
}


