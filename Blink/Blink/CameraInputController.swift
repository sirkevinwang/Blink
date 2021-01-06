//
//  CameraInput.swift
//  Blink
//
//  Created by Kevin Wang on 1/5/21.
//

import AVFoundation
import CoreImage

final class CameraInputController: NSObject, ObservableObject {
    @Published var blinkCount = 0
    var blinkCache = [Int]()
    private var faceDetector: CIDetector? = {
        let detectorOptions = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: detectorOptions)
        return detector
    }()
    private lazy var sampleBufferDelegateQueue = DispatchQueue(label: "CameraInput")
    private let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown, .builtInMicrophone, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)

    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .vga640x480
        let device = getAVCaptureDevice(at: 1)
        let input = try! AVCaptureDeviceInput(device: device)
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferMetalCompatibilityKey as String: true
        ]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: self.sampleBufferDelegateQueue)
        session.addOutput(output)
        
        return session
    }()
    
    var timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkBlinkCount), userInfo: nil, repeats: true)
    
    func getAVCaptureDevice(at index: Int) -> AVCaptureDevice {
        let devices = self.deviceDiscoverySession.devices
        guard !devices.isEmpty else {
            // TOOD: handle no capture device here
            fatalError("Missing capture devices.")
        }
        return devices[index]
    }
}

extension CameraInputController {
    func start() {
        self.timer.invalidate()
        guard !self.captureSession.isRunning else {
            return
        }
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkBlinkCount), userInfo: nil, repeats: true)
        self.captureSession.startRunning()
    }
    
    func stop() {
        self.timer.invalidate()
        guard self.captureSession.isRunning else {
            return
        }
        self.captureSession.stopRunning()
    }
    
    @objc func checkBlinkCount() {
        if blinkCount < 15 {
            print("blink too slow")
        } else {
            print("great job")
        }
        blinkCount = 0
    }
}

extension CameraInputController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let detector = self.faceDetector {
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
            let options = [CIDetectorEyeBlink: true, CIDetectorImageOrientation : 1] as [String : Any]
            let features = detector.features(in: cameraImage, options: options)
            
            if (features.count == 1) {
                for feature in features as! [CIFaceFeature] {
                    if (feature.leftEyeClosed && feature.rightEyeClosed && feature.faceAngle <= 25 && feature.faceAngle >= -25) {
                        blinkCache.append(1)
                        
                        if blinkCache.count > 4 {
                            blinkCache.remove(at: 0)
                        }
                        
                        if blinkCache.reduce(0, +) == 1 {
                            blinkCount += 1
                            print(blinkCount)  
                        }
                        
                    } else {
                        blinkCache.append(0)
                        
                        if blinkCache.count > 4 {
                            blinkCache.remove(at: 0)
                        }
                    }
                }
            }
        }
    }
}
