//
//  CameraInput.swift
//  Blink
//
//  Created by Kevin Wang on 1/5/21.
//

import AVFoundation
import CoreImage
import Cocoa

import AppCenter
import AppCenterAnalytics

final class CameraInputController: NSObject, ObservableObject {
    @Published var isTracking = false
    @Published var captureDeviceIndex = 0
    var lowPowerMode = false
    let EXPECTED_BLINK_COUNT = 15
    var blinkCount = 0
    var blinkCache = [Int]()
    var noFaceMinutes = 0
    let minCheckOnlineDelay = 30
    let maxCheckOnlineDelay = 240 // Don't go above this value -- check 1 every 5 minutes when offline.
    var checkOnlineDelay = 30 // If offline, go back online for a minute every 30 sceonds then increases to 60, 120, then stays at 240.
    private var faceDetector: CIDetector? = {
        let detectorOptions = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: detectorOptions)
        return detector
    }()
    private lazy var sampleBufferDelegateQueue = DispatchQueue(label: "CameraInput")
    private var deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown, .builtInMicrophone, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        let device = getAVCaptureDevice(at: captureDeviceIndex)
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
    
    func setAVCaptureDevice() {
        let device = getAVCaptureDevice(at: captureDeviceIndex)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if let originalInput = captureSession.inputs.first {
                captureSession.removeInput(originalInput)
            }
            captureSession.addInput(input)
        } catch {
            // checks for no camera
            let alert = NSAlert()
            alert.alertStyle = .critical
            if self.getAVCaptureDevices().isEmpty {
                alert.messageText = "No Camera Detected"
                alert.informativeText = "Make sure you have connected at least one camera."

            } else {
                alert.messageText = "Cannot Access Camera"
                alert.informativeText = "Make sure you have given Blink permission to use your camera. Open System Preferences and navigate to Security & Privacy > Camera to grant Blink permission to access your camera."
            }
            alert.runModal()
            NSApp.terminate(self)
        }
    }
    
    func getAVCaptureDevice(at index: Int) -> AVCaptureDevice {
        let devices = getAVCaptureDevices()
        guard !devices.isEmpty else {
            fatalError("Missing capture devices.")
        }
        return devices[index]
    }
    
    func getAVCaptureDevices() -> [AVCaptureDevice] {
        self.deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown, .builtInMicrophone, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        return self.deviceDiscoverySession.devices
    }
}

extension CameraInputController {
    func start() {
        self.timer.invalidate()
        self.blinkCount = 0
        self.blinkCache = [Int]()
        self.noFaceMinutes = 0
        guard !self.captureSession.isRunning else {
            return
        }
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkBlinkCount), userInfo: nil, repeats: true)
        self.captureSession.startRunning()
        self.isTracking = true
//        self.lowPowerMode = false
    }
    
    func stop() {
        self.timer.invalidate()
        guard self.captureSession.isRunning else {
            return
        }
        self.captureSession.stopRunning()
        self.isTracking = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.checkOnlineDelay)) {
            self.start()
        }
//        self.lowPowerMode = false
    }
    
    @objc func checkBlinkCount() {
        if blinkCount < EXPECTED_BLINK_COUNT {
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            if blinkCount == 0 {
                // no face detected
                checkOnlineDelay = min(checkOnlineDelay * 2, maxCheckOnlineDelay) // Double the offline checking delay upto 4 minutes
                if noFaceMinutes + 1 >= 2 {
                    self.stop()
                    appDelegate.showNoFaceDetectedAlert()
                    Analytics.trackEvent("No face detected")

                } else {
                    noFaceMinutes += 1
                }
            } else {
                // too few blinks
//                print("blink too slow")
                Analytics.trackEvent("low blink count", withProperties: ["blinks" : "\(blinkCount)"])
                appDelegate.showLowBlinkCountAlert(blinkCnt: blinkCount)
                blinkCount = 0
                checkOnlineDelay = minCheckOnlineDelay // Reset offline checking
//                self.lowPowerMode = false
            }
        } else {
            Analytics.trackEvent("good count", withProperties: ["blinks" : "\(blinkCount)"])
            blinkCount = 0
            checkOnlineDelay = minCheckOnlineDelay // Reset offline checking
//            self.lowPowerMode = false
        }
    }
}

extension CameraInputController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let detector = self.faceDetector {
//            if !lowPowerMode {
                let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
                let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
                let options = [CIDetectorEyeBlink: true, CIDetectorImageOrientation : 1] as [String : Any]
                let features = detector.features(in: cameraImage, options: options)
                
                if (features.count == 1) {
                    let feature = features.first as! CIFaceFeature
                    if (feature.leftEyeClosed || feature.rightEyeClosed && feature.faceAngle <= 25 && feature.faceAngle >= -25) {
                        blinkCache.append(1)
                        
                        if blinkCache.count > 3 {
                            blinkCache.remove(at: 0)
                        }
                        
                        if blinkCache.reduce(0, +) == 1 {
                            blinkCount += 1
                            if blinkCount >= EXPECTED_BLINK_COUNT {
//                                self.lowPowerMode = true
                            }
//                            print(blinkCount)
                        }
                        
                    } else {
                        blinkCache.append(0)
                        if blinkCache.count > 3 {
                            blinkCache.remove(at: 0)
                        }
                    }
                    
                }
//            }
        }
    }
}
