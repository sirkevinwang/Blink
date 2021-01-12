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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // this prevents the app icon from showing in Dock
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)
        constructMenu()
        camera.start()
    }
    
    func constructMenu() {
        let menu = NSMenu()
        let toggleViewItem = NSMenuItem()
        let toggleView = MenuToggleView(camera: camera)
        toggleViewItem.view = NSHostingView(rootView: toggleView)
        toggleViewItem.view?.frame = CGRect(x: 0, y: 0, width: 250.0, height: 50.0)
        menu.addItem(toggleViewItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About", action: #selector(self.openAboutView), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    func constructStatusItem() {
        // TODO: add image to status bar item
//        statusItem.button = NSStatusBarButton(image: NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil), target: nil, action: nil)
    }
    
    // TODO: show device picker
    func constructCaptureDevicesMenu() {
        
    }
    
    @objc func openAboutView() {
        let aboutView = AboutView()

        // Create the window and set the content view.
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

