//
//  UserDefaults+Preferences.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 13.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation

extension UserDefaults {
  
  @objc dynamic var colorScheme: String {
    return string(forKey: Preferences.Key.colorScheme.rawValue) ?? ""
  }
}
