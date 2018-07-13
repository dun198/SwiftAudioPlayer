//
//  AppState.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 14.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Foundation


protocol ViewModelProtocol {
  var colorScheme: ViewModel.ColorScheme { get set }
}

struct ViewModel: ViewModelProtocol {
  
  enum ColorScheme: String, CaseIterable {
    case system = "System"
    case dark = "Dark"
    case light = "Light"
    
    static let allValues = [system, dark, light]
  }
  
  var colorScheme: ColorScheme
 
  init(colorScheme: ColorScheme = .system) {
    self.colorScheme = .system
  }
}
