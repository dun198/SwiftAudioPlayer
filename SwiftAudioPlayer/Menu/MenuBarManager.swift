//
//  MenuBarManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 13.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MenuBarManager: NSObject {

  static let shared = MenuBarManager()
  
  @IBAction func changeColorScheme(_ sender: NSMenu) {

  }
  
}

extension MenuBarManager: ColorSchemeMenuDelegate {
  func colorSchemeMenu(_ menu: NSMenu, didSelectColorScheme colorScheme: Preferences.ColorScheme) {
    print(colorScheme.rawValue)
  }
}
