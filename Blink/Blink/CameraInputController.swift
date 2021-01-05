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
    private var faceDetector: CIDetector? = {
        let detectorOptions = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: detectorOptions)
        return detector
    }()
    private lazy var sampleBufferDelegateQueue = DispatchQueue(label: "CameraInput")
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .hd1280x720

        let device = AVCaptureDevice.default(for: .video)!
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
}

extension CameraInputController {
    func start() {
        guard !self.captureSession.isRunning else {
            return
        }

        self.captureSession.startRunning()
    }

    func stop() {
        guard self.captureSession.isRunning else {
            return
        }

        self.captureSession.stopRunning()
    }
}

extension CameraInputController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let detector = self.faceDetector {
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
            let options = [CIDetectorEyeBlink: true, CIDetectorImageOrientation : 1] as [String : Any]
            let features = detector.features(in: cameraImage, options: options)
            if (features.count != 0) {
               for feature in features as! [CIFaceFeature] {
                  if (feature.leftEyeClosed && feature.rightEyeClosed && feature.faceAngle <= 5 && feature.faceAngle >= -5) {
                  }
               }
            }
        }
    }
}
