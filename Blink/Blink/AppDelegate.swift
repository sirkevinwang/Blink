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
        constructMenu()
        camera.start()
    }
    
    func constructMenu() {
        let menu = NSMenu()
        let toggleViewItem = NSMenuItem()
        let toggleView = MenuToggleView()
        toggleViewItem.view = NSHostingView(rootView: toggleView)
        toggleViewItem.view?.frame = CGRect(x: 0, y: 0, width: 200.0, height: 50.0)
        menu.addItem(toggleViewItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
}

