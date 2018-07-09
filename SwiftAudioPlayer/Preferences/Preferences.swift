//
//  Preferences.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 20.06.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation

struct Preferences {
  
  struct Key: RawRepresentable, Hashable {
    typealias RawValue = String
    var rawValue: RawValue
    var hashValue: Int {
      return rawValue.hashValue
    }
    
    static let quitAfterWindowClosed = Key(rawValue: "quitAfterWindowClosed")
    static let colorScheme = Key(rawValue: "colorScheme")
    static let fadeControlsWhenScrolling = Key(rawValue: "fadeControls")
    static let controlsVisibility = Key(rawValue: "controlsVisibility")
  }
  
  // MARK: - Defaults
  
  static let defaultPreferences: [Preferences.Key: Any] = [
    .quitAfterWindowClosed: false,
    .colorScheme: ColorScheme.system.rawValue,
    .fadeControlsWhenScrolling: true,
    .controlsVisibility: 0.2
  ]
}
