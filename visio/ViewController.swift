//
//  ViewController.swift
//  visio
//
//  Created by Gurudutt on 1/21/20.
//  Copyright © 2020 Gurudutt Perichetla. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

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
        captureSession.addOutput(cameraOutput)
        
        
        // Displaying output
        
        let cameraPreview = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreview.frame = CGRect(x:0, y:0, width: cameraView.frame.size.width, height: cameraView.frame.size.height)
        cameraView.layer.addSublayer(cameraPreview)
        
        
        
        
    }


}

