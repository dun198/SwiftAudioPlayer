//
//  ColorSchemeMenu.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 09.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

@objc protocol ColorSchemeMenuDelegate {
  func test()
}

class ColorSchemeMenu: NSMenu {
  
  @IBOutlet weak var menuDelegate: ColorSchemeMenuDelegate?
  
  var colorScheme: ViewModel.ColorScheme = .system {
    didSet {
      updateMenuItems()
      guard let windowController = NSApp.mainWindow?.windowController as? MainWindowController else { return }
      windowController.colorScheme = colorScheme
    }
  }
  
  override init(title: String) {
    super.init(title: title)
    setup()
  }

  required init(coder decoder: NSCoder) {
    super.init(coder: decoder)
    setup()
  }
  
  private func setup() {
    for theme in ViewModel.ColorScheme.allCases {
      let item = NSMenuItem()
      item.title = theme.rawValue
      item.action = #selector(handleSetColorScheme(_:))
      item.target = self
      self.addItem(item)
    }
    let colorSchemeName = UserDefaults.standard.string(forKey: Preferences.Key.colorScheme.rawValue) ?? "System"
    self.colorScheme = ViewModel.ColorScheme(rawValue: colorSchemeName) ?? .system
  }
  
  private func updateMenuItems() {
    for item in self.items {
      item.image = item.title == colorScheme.rawValue ? item.onStateImage : item.offStateImage
      item.isEnabled = item.title == colorScheme.rawValue ? false : true
      item.target = item.title == colorScheme.rawValue ? nil : self
    }
  }
  
  @objc private func handleSetColorScheme(_ sender: NSMenuItem?) {
    menuDelegate?.test()
    colorScheme = ViewModel.ColorScheme(rawValue: sender?.title ?? colorScheme.rawValue) ?? colorScheme
  }
}

extension ColorSchemeMenu: NSMenuDelegate {
}
