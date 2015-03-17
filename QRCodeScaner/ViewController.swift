//
//  ViewController.swift
//  QRCodeScaner
//
//  Created by Allen Lai on 15/03/2015.
//  Copyright (c) 2015 Allen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var scanCodeOutput: UILabel!    
    
    var device: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    lazy var deviceInput: AVCaptureDeviceInput = {
        return AVCaptureDeviceInput(device: self.device, error: nil)
    }()
    var metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    var session: AVCaptureSession = AVCaptureSession()
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self.session)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session.addOutput(metadataOutput)
        session.addInput(deviceInput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
//        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for current in metadataObjects {
            if var readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
                scanCodeOutput.text = readableCodeObject.stringValue
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

