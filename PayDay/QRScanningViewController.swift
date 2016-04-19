//
//  QRScanningViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 3/15/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScanningViewControllerDelegate {
    func qrCodeFromQRViewController(string: String)
    func goFromQRCode()
}


class QRScanningViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var cameraView: UIView!
    
    var delegate: QRScanningViewControllerDelegate!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var isFrontCamera = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let captureDevice = (AVCaptureDevice.devices()
                .filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == .Back})
                .first as? AVCaptureDevice
            else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode93Code]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 155)
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderWidth = 3
                
                cameraView.addSubview(qrCodeFrameView)
                cameraView.bringSubviewToFront(qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
        isFrontCamera = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            
            print("QR Code is not detected")
            
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        
        var token: dispatch_once_t = 0
        dispatch_once(&token) {
        
        if metadataObj.stringValue != nil {
            
            print("QR code\(metadataObj.stringValue)")
            
            self.delegate.qrCodeFromQRViewController(metadataObj.stringValue)
            
            }
            
            self.dismissViewControllerAnimated(true, completion: {
                self.delegate.goFromQRCode()

            })
        }
        
    }
    
    @IBAction func useKeyPadPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func changeCamera(sender: AnyObject) {
        
        if isFrontCamera {
            guard
                let captureDevice = (AVCaptureDevice.devices()
                    .filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == .Back})
                    .first as? AVCaptureDevice
                else { return }
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode93Code]
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 155)
                cameraView.layer.addSublayer(videoPreviewLayer!)
                
                captureSession?.startRunning()
                
                
                qrCodeFrameView = UIView()
                
                if let qrCodeFrameView = qrCodeFrameView {
                    qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                    qrCodeFrameView.layer.borderWidth = 3
                    
                    cameraView.addSubview(qrCodeFrameView)
                    cameraView.bringSubviewToFront(qrCodeFrameView)
                }
            } catch {
                print(error)
                return
            }
            isFrontCamera = false
            
        } else {
            guard
                let captureDevice = (AVCaptureDevice.devices()
                    .filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == .Front})
                    .first as? AVCaptureDevice
                else { return }
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode93Code]
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 155)
                cameraView.layer.addSublayer(videoPreviewLayer!)
                
                captureSession?.startRunning()
                
                
                qrCodeFrameView = UIView()
                
                if let qrCodeFrameView = qrCodeFrameView {
                    qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                    qrCodeFrameView.layer.borderWidth = 3
                    
                    cameraView.addSubview(qrCodeFrameView)
                    cameraView.bringSubviewToFront(qrCodeFrameView)
                }
            } catch {
                print(error)
                return
            }
            isFrontCamera = true
        }
        
    }
    
    
    

    
}

