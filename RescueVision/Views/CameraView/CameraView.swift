//
//  CameraView.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-16.
//

import SwiftUI

//actual cameraview to use in content.
//checks auth and starts session on appear.
struct CameraView: View {
    @EnvironmentObject var viewModel:ObjectDetectionViewModel
    var body: some View {
        ZStack{
            CameraPreview(camera: viewModel.camera)
        }.onAppear(perform: {
            viewModel.camera.check()
            viewModel.camera.session.startRunning()
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
