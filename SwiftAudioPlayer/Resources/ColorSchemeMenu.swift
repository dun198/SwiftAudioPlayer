//
//  ColorSchemeMenu.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 09.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ColorSchemeMenu: NSMenu {
  
  var colorScheme: ColorScheme = ColorScheme.system {
    didSet {
      print("did set color scheme to \(colorScheme.rawValue)")
      guard let windowController = NSApp.mainWindow?.windowController as? MainWindowController else { return }
      windowController.colorScheme = colorScheme
    }
  }
  
  override init(title: String) {
    super.init(title: title)
    setupMenu()
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
    setupMenu()
  }
  
  private func setupMenu() {
    for theme in ColorScheme.allValues {
      let menuItem = NSMenuItem(title: theme.rawValue, action: #selector(handleSetColorScheme(_:)), keyEquivalent: "")
      menuItem.target = self
      menuItem.isEnabled = menuItem.title == colorScheme.rawValue
      self.addItem(menuItem)
    }
  }
  
  @objc private func handleSetColorScheme(_ sender: NSMenuItem?) {
    colorScheme = ColorScheme(rawValue: sender?.title ?? colorScheme.rawValue) ?? colorScheme
  }
}
