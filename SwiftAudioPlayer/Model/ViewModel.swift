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

enum ColorScheme {
    case dark
    case light
}

protocol ViewModelProtocol {
    var uiState: Dynamic<UIState> { get }
    func changeUIstate(to state: UIState)

    var colorScheme: Dynamic<ColorScheme> { get }
    func changeColorScheme(to colorScheme: ColorScheme)

}

struct ViewModel:  ViewModelProtocol {

    let uiState: Dynamic<UIState>
    let colorScheme: Dynamic<ColorScheme>

    func changeUIstate(to state: UIState) {
        self.uiState.value = state
        print("uiState changed to \(state)")
    }

    func changeColorScheme(to colorScheme: ColorScheme) {
        self.colorScheme.value = colorScheme
        print("colorScheme changed to \(colorScheme)")
    }

    init() {
        self.uiState = Dynamic(.narrow)
        self.colorScheme = Dynamic(.dark)
    }
}
