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

protocol ViewModelProtocol {
    var uiState: Dynamic<UIState> { get }
    func changeUIstate(to state: UIState)
}

class ViewModel: NSObject, ViewModelProtocol {
    
    let uiState: Dynamic<UIState>
    
    func changeUIstate(to state: UIState) {
        self.uiState.value = state
        print("uiState changed to \(state)")
    }

    
    override init() {
        self.uiState = Dynamic(.narrow)
        super.init()
    }
}
