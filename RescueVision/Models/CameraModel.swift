//
//  CameraModel.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-16.
//

import Foundation
import AVKit
import Vision
import Combine

class CameraModel: NSObject, ObservableObject,AVCaptureVideoDataOutputSampleBufferDelegate {
   
    var session = AVCaptureSession()
    var preview: AVCaptureVideoPreviewLayer!
    private var output = AVCaptureVideoDataOutput()
    
    //name and status for DB look up.
    @Published var foundObjectName:String = ""
    @Published  var foundObject:Bool = false
    
    
    
    private let outputQue:DispatchQueue = DispatchQueue(label: "videoOutputQue")
    private var bufferSize:CGSize = .zero
    private var requests = [VNRequest]()
    
    
    func showRecognizedObj(_ results: [Any]){
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            let topLableObservation = objectObservation.labels[0]
            if topLableObservation.confidence > 0.9{
                toggleOutput()
                
                self.foundObjectName = "\(topLableObservation.identifier)"
                self.foundObject = true
                
            }
        }
    }
    
    func toggleOutput(){
        if let output =  output.connection(with: .video){
            if output.isEnabled {
                output.isEnabled = false
            }else{
                output.isEnabled = true
                foundObject = false
            }
        }
        
    }
    
    func setupVision(){
        
        guard let url = Bundle.main.url(forResource: "RSQ1", withExtension: "mlmodelc") else {
            fatalError("no such file")
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: url))
            let objectDetection = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute:{
                    if let result = request.results{
                        self.showRecognizedObj(result)
                    }
                })
            })
            self.requests = [objectDetection]
        } catch  {
            fatalError("model loading failed: \(error)")
        }
    }
    
    //feeds output to visionModel.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("no buffer")
            return
        }
        let imageRequestHandeler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try imageRequestHandeler.perform(self.requests)
        } catch  {
            print(error)
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //runs on every dorpped capture frame.
    }
    
    //Check camera auth
    func check(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ status in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            return
        default:
            return
        }
    }
    
    //Setup camera session.
    func setUp() {
        var input: AVCaptureDeviceInput!
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            input = try AVCaptureDeviceInput(device: videoDevice!)
        } catch  {
            print("couldn't create device: \(error)")
            return
        }
        //Device is set and ready to be configured.
        self.session.beginConfiguration()
        self.session.sessionPreset = .vga640x480
        
        if self.session.canAddInput(input) {
            self.session.addInput(input)
        }
        
        
        if self.session.canAddOutput(output){
            self.session.addOutput(output)
            
            // Setup output
            //dont't fill up que while working
            output.alwaysDiscardsLateVideoFrames = true
            
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            output.setSampleBufferDelegate(self, queue: outputQue)
        }
        
        // start output connection
        let captureConnection = output.connection(with: .video)
        captureConnection?.isEnabled = true
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            //Set size of buffer
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            
            videoDevice!.unlockForConfiguration()
            
        } catch  {
            print("connection failed:\(error)")
        }
        
        self.session.commitConfiguration()
        
    }
}
