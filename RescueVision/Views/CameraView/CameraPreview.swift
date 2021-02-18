//
//  CameraPreview.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-16.
//

import SwiftUI
import AVKit

struct CameraPreview: UIViewRepresentable {
  @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }

    
}

