//
//  AppDelegate.swift
//  Blink
//
//  Created by Kevin Wang on 1/4/21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    @ObservedObject var camera = CameraInputController()
    var cameraMenuItems: [NSMenuItem] = []
    let menu = NSMenu()
    
    let defaults = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCameraMenu), name: NSNotification.Name.AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCameraMenu), name: NSNotification.Name.AVCaptureDeviceWasDisconnected, object: nil)
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        
        constructStatusMenu()
        camera.start()
    }
    
    @objc func updateCameraMenu() {
        cameraMenuItems.forEach { menu.removeItem($0) }
        cameraMenuItems = []
        constructCaptureDevicesMenu()
    }
    
    func constructStatusMenu() {
        constructStartStopMenu()
        
        menu.addItem(NSMenuItem.separator())
        let cameraItem = NSMenuItem(title: "Camera", action: nil, keyEquivalent: "")
        menu.addItem(cameraItem)
        
        constructCaptureDevicesMenu()
        constructMiscMenu()
    }
    
    func constructCaptureDevicesMenu() {
        let devices = camera.getAVCaptureDevices()
        if devices.isEmpty {
            // FIXME: untested code
            let alert = NSAlert()
            alert.messageText = "No Camera Detected"
            alert.informativeText = "Make sure that you have connected to at least one camera before using Blink."
            alert.runModal()
            NSApp.terminate(self)
        } else {
//            // catches hot unplug of AVCaptureDevice
//            if camera.captureDeviceIndex >= devices.count {
//                camera.captureDeviceIndex = 0
//                camera.setAVCaptureDevice()
//            }
            
            // load camera name in defaults if set
            var preferredCameraName = ""
            if let camName = defaults.value(forKey: "preferredCameraName") {
                preferredCameraName = camName as! String
            }
            
            // create checkbox menu items for each camera
            for i in (0...devices.count - 1).reversed() {
                let device = devices[i]
                let deviceItem = NSMenuItem(title: device.localizedName, action: #selector(self.toggleCameraDevice), keyEquivalent: "")
                deviceItem.tag = i
                
                if preferredCameraName != "" && device.localizedName == preferredCameraName {
                    cameraMenuItems.forEach { $0.state = .off }
                    camera.captureDeviceIndex = i
                    camera.setAVCaptureDevice()
                }
                
                if camera.captureDeviceIndex == i {
                    deviceItem.state = .on
                } else {
                    deviceItem.state = .off
                }
                deviceItem.indentationLevel = 1
                menu.insertItem(deviceItem, at: 3)
                cameraMenuItems.insert(deviceItem, at: 0)
            }
        }
    }
    
    func constructStartStopMenu() {
        let toggleViewItem = NSMenuItem()
        let toggleView = MenuToggleView(camera: camera)
        toggleViewItem.view = NSHostingView(rootView: toggleView)
        toggleViewItem.view?.frame = CGRect(x: 0, y: 0, width: 250.0, height: 50.0)
        menu.addItem(toggleViewItem)
    }
    
    func constructMiscMenu() {
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About", action: #selector(self.openAboutView), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        statusItem.menu = menu
    }
    
    func constructStatusItem() {
        // TODO: add image to status bar item
//        statusItem.button = NSStatusBarButton(image: NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil), target: nil, action: nil)
    }
    
    @objc func toggleCameraDevice(sender: NSMenuItem) {
        let newDeviceIndex = sender.tag
        if newDeviceIndex == camera.captureDeviceIndex {
            return
        }
        cameraMenuItems[camera.captureDeviceIndex].state = .off
        
        
        // update preferred camera in defaults
        defaults.set(sender.title, forKey: "preferredCameraName")
        
        camera.captureDeviceIndex = newDeviceIndex
        camera.setAVCaptureDevice()
        cameraMenuItems[newDeviceIndex].state = .on
    }
    
    @objc func openAboutView() {
        let aboutView = AboutView()

        // Create the window and set the content view.
        // FIXME: need to put this window on the top
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 250.0, height: 350.0),
            styleMask: [.closable, .titled, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.titleVisibility = .hidden
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.isReleasedWhenClosed = false
        window.contentView?.wantsLayer = true
        window.center()
        window.contentView = NSHostingView(rootView: aboutView)
        window.titlebarAppearsTransparent = true
        window.isOpaque = false
        window.makeKeyAndOrderFront(nil)
    }
    
    func showLowBlinkCountAlert(blinkCnt: Int) {
        showAlert(of: .lowBlinkCount, blinkCnt: blinkCnt)
    }
    
    func showNoFaceDetectedAlert() {
        showAlert(of: .noFaceDetected, blinkCnt: nil)
    }
    
    func showAlert(of type: BlinkAlertType, blinkCnt: Int?) {
        print(blinkCnt)
        var alert = AlertView(alertText: "Blink More", alertIcon: Image(systemName: "eyebrow"), blinks: blinkCnt)
        if type == .noFaceDetected {
            alert = AlertView(alertText: "Tracking Paused", alertIcon: Image(systemName: "pause.circle.fill"), blinks: blinkCnt)
        }
        
        let alertHostedView = NSHostingView(rootView: alert)
        let bzNotification = BezelNotification(dismissInterval: 3.5, hostedView: alertHostedView)
        bzNotification.runModal()
    }
    
    enum BlinkAlertType {
        case lowBlinkCount
        case noFaceDetected
    }
}

