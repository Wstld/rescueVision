//
//  VideoPlayer.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-21.
//

import SwiftUI
struct  PlayBtn: View {
    @State private var isPlaying = false
    var action: () -> Void
    
    var body: some View{
        GeometryReader{ geo in
            Image(systemName: "play.circle.fill")
                .resizable()
                .foregroundColor(.gray)
                .opacity(0.7)
                .frame(width:geo.size.width/2 , height: geo.size.width/2, alignment:.center)
                .position(x: geo.size.width/2, y: geo.size.height/2)
        }
    }
    private func btnTapped(){
        isPlaying.toggle()
        action()
    }
}


struct VideoView: View {
    @StateObject var videoPlayer = VideoPlayerModel()
    
    var videoURL:String
    
    var body: some View {
        GeometryReader{ geo in
            VStack {
                ZStack{
                    VideoPreview(videoPlayer: videoPlayer,videoURL: videoURL)
                        .onTapGesture {
                            videoPlayer.play()
                        }
                    if videoPlayer.isPlaying == false {
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
                }
            }
        }
        
    }
}


