//
//  AppDelegate.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var viewController: MainSplitViewController!
    
    var darkMode = true
    var bypassDidResize = false
    var colorScheme: ColorScheme = ColorScheme.dark {
        didSet {
            //toggleAppearance()
        }
    }
    
    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        viewModel = ViewModel()
        setupWindow()
    }
    
    private func setupWindow() {
        viewController = MainSplitViewController()
        window = NSWindow(contentViewController: viewController)
        
        window.delegate = self
        window.contentView = viewController.view
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.styleMask.insert([.fullSizeContentView])
        window.appearance = NSAppearance(named: .vibrantDark)
        window.toolbar = NSToolbar(identifier: NSToolbar.Identifier.init("MainToolbar"))
        window.toolbar?.showsBaselineSeparator = false
        window.toolbar?.allowsUserCustomization = false
        window.toolbar?.isVisible = true
        
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let dockMenu = NSMenu(title: "Dock Menu")
        dockMenu.addItem(NSMenuItem(title: "Title", action: nil, keyEquivalent: ""))
        return dockMenu
    }
    
    private func updateWindowState() {
        window?.update()
    }
    
    private func toggleAppearance() {
        if !darkMode {
            self.window?.appearance = NSAppearance(named: .vibrantDark)
        } else {
            self.window?.appearance = NSAppearance(named: .vibrantLight)
        }
        darkMode = !darkMode
    }
}

extension AppDelegate: NSWindowDelegate {
    
    func windowDidEnterFullScreen(_ notification: Notification) {
    }
    
    func windowWillEnterFullScreen(_ notification: Notification) {
        window?.toolbar?.isVisible = false
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        window?.toolbar?.isVisible = true
    }
}
