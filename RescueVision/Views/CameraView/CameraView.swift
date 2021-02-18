//
//  CameraView.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-16.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var viewModel:ObjectDetectionViewModel
    var body: some View {
        ZStack{
            CameraPreview(camera: viewModel.camera)
        }.onAppear(perform: {
            viewModel.camera.check()
            //start session
            viewModel.camera.session.startRunning()
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
