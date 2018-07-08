//
//  AppState.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 14.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Foundation

enum ColorScheme: String {
  case system = "System"
  case dark = "Dark"
  case light = "Light"
  
  static let allValues = [system, dark, light]
}

protocol ViewModelProtocol {
  var colorScheme: Dynamic<ColorScheme> { get }
  func changeColorScheme(to colorScheme: ColorScheme)
}

struct ViewModel:  ViewModelProtocol {
  
  let colorScheme: Dynamic<ColorScheme>
  
  func changeColorScheme(to colorScheme: ColorScheme) {
    self.colorScheme.value = colorScheme
    print("colorScheme changed to \(colorScheme)")
  }
  
  init() {
    self.colorScheme = Dynamic(.system)
  }
}
