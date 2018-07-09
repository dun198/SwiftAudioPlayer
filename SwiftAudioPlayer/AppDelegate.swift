//
//  AppDelegate.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var windowController: MainWindowController!
  
  /// The instance of `RemoteCommandManager` that the app uses for managing remote command events.
  var remoteCommandManager: RemoteCommandManager!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    setUserDefaults()
    
    // Initializer the `RemoteCommandManager`.
    remoteCommandManager = RemoteCommandManager()
    
    // Always enable playback commands in MPRemoteCommandCenter.
    remoteCommandManager.activatePlaybackCommands(true)
        
    windowController = MainWindowController()
    windowController.loadWindow()
  }
  
  func applicationWillBecomeActive(_ notification: Notification) {
    if windowController.window?.isVisible == false {
      windowController.showWindow(self)
    }
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      windowController.showWindow(sender)
      return true
    }
    return false
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return UserDefaults.standard.bool(forKey: Preferences.Key.quitAfterWindowClosed.rawValue)
  }
  
  func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
    let dockMenu = NSMenu(title: "Dock Menu")
    dockMenu.addItem(NSMenuItem(title: "Title", action: nil, keyEquivalent: ""))
    return dockMenu
  }
  
  private func setUserDefaults() {
    UserDefaults.standard.register(defaults: [String : Any](uniqueKeysWithValues: Preferences.defaultPreferences.map { ($0.0.rawValue, $0.1) }))
  }

}
