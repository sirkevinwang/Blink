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
    
    var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let camera = CameraInputController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        constructMenu()
        camera.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
}

