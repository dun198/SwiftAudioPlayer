//
//  ColorSchemeMenu.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 09.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol ColorSchemeMenuDelegate {
  func colorSchemeMenu(_ menu: NSMenu, didSelectColorScheme colorScheme: Preferences.ColorScheme)
}

class ColorSchemeMenu: NSMenu {
  
  var menuDelegate: ColorSchemeMenuDelegate?
  var observer: NSKeyValueObservation?

  var selectedColorSchemeName: String! {
    didSet {
      updateMenuItems()
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
    self.removeAllItems()
    for theme in Preferences.ColorScheme.allCases {
      let item = NSMenuItem()
      item.title = theme.rawValue
      item.action = #selector(handleSetColorScheme(_:))
      item.target = self
      self.addItem(item)
    }
    self.selectedColorSchemeName = UserDefaults.standard.string(forKey: Preferences.Key.colorScheme.rawValue) ?? "System"

    observer = UserDefaults.standard.observe(\.colorScheme, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
      self?.selectedColorSchemeName = change.newValue
    })
  }
  
  deinit {
    observer?.invalidate()
  }
  
  private func updateMenuItems() {
    for item in self.items {
      item.state = item.title == selectedColorSchemeName ? NSControl.StateValue.on : NSControl.StateValue.off
    }
  }
  
  @objc private func handleSetColorScheme(_ sender: NSMenuItem?) {
    guard let colorSchemeName = sender?.title else { return }
    UserDefaults.standard.set(colorSchemeName, forKey: Preferences.Key.colorScheme.rawValue)
  }
}
