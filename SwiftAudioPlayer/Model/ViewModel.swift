//
//  AppState.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 14.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Foundation

enum UIState {
  case narrow
  case medium
  case wide
}

enum ColorScheme: String {
  case dark = "Dark"
  case light = "Light"
  
  static let allValues = [dark, light]
}

protocol ViewModelProtocol {
  var uiState: Dynamic<UIState> { get }
  func changeUI(to state: UIState)
  
  var colorScheme: Dynamic<ColorScheme> { get }
  func changeUI(to colorScheme: ColorScheme)
  
}

struct ViewModel:  ViewModelProtocol {
  
  let uiState: Dynamic<UIState>
  let colorScheme: Dynamic<ColorScheme>
  
  func changeUI(to state: UIState) {
    self.uiState.value = state
    print("uiState changed to \(state)")
  }
  
  func changeUI(to colorScheme: ColorScheme) {
    self.colorScheme.value = colorScheme
    print("colorScheme changed to \(colorScheme)")
  }
  
  init() {
    self.uiState = Dynamic(.narrow)
    self.colorScheme = Dynamic(.dark)
  }
}
