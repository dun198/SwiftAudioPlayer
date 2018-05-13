//
//  DarkMode.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

/// Check or get notified about macOS Dark Mode status
public final class DarkMode {
  private static let notificationName = NSNotification.Name("AppleInterfaceThemeChangedNotification")
  
  static var onChange: ((Bool) -> Void)? {
    didSet {
      if onChange == nil {
        DistributedNotificationCenter.default().removeObserver(self, name: notificationName, object: nil)
      } else {
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(selectorHandler), name: notificationName, object: nil)
      }
    }
  }
  
  static var isEnabled: Bool {
    return UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
  }
  
  static var blackColor: NSColor {
    return isEnabled ? .white : .black
  }
  
  @objc
  private static func selectorHandler() {
    onChange?(isEnabled)
  }
}
