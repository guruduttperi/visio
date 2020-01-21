//
//  ViewController.swift
//  visio
//
//  Created by Gurudutt on 1/21/20.
//  Copyright © 2020 Gurudutt Perichetla. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Getting Device Input
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{
            return
        }
        
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        // Getting Camera Output
        
        let cameraOutput = AVCaptureVideoDataOutput()
        cameraOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
        captureSession.addOutput(cameraOutput)
        
        
        // Displaying output
        
        let cameraPreview = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreview.frame = CGRect(x:0, y:0, width: cameraView.frame.size.width, height: cameraView.frame.size.height)
        cameraView.layer.addSublayer(cameraPreview)
    
        
    }

    // Capturing Camera Frames
    private func cameraOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        
        //print(sampleBuffer)
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        detectImage(pixelBuffer: pixelBuffer)
        
    }
    
    
    
    func detectImage(pixelBuffer: CVPixelBuffer){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            return
        }
        
        let request = VNCoreMLRequest(model: model){
            (request, error) in
            guard let results  = request.results as? [VNClassificationObservation] else {return}
            guard let firstResult = results.first else {return}
            
            print(firstResult.identifier)
             DispatchQueue.main.async {
                self.resultLabel.text = firstResult.identifier
            }
            
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        DispatchQueue.global().async {
            try? handler.perform([request])
        }
    }
    

}

