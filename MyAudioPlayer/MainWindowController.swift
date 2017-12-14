//
//  PlayerWindowController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    var darkMode = true
    
    @IBAction func toggleAppearanceAction(_ sender: Any) {
        
        if !darkMode {
            self.window?.appearance = NSAppearance(named: .vibrantDark)
        } else {
            self.window?.appearance = NSAppearance(named: .vibrantLight)
        }
        
        darkMode = !darkMode
    }
    
    
    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }
    
    lazy var mainView: MainViewController? = contentViewController as? MainViewController

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.appearance = NSAppearance(named: .vibrantDark)
        self.window?.isOpaque = true
        self.window?.titleVisibility = .hidden
        
        viewModel = ViewModel()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    
    
}

extension MainWindowController: NSWindowDelegate {
    
    func windowDidEnterFullScreen(_ notification: Notification) {
        self.window?.styleMask.insert(.texturedBackground)
    }
    
    func windowWillExitFullScreen(_ notification: Notification) {
        self.window?.styleMask.remove(.texturedBackground)
    }
    
    func windowDidResize(_ notification: Notification) {
        guard let width = self.window?.frame.width else { return }
        guard let uiState = viewModel?.uiState.value else { return }
        
        print(width)
        
        if width >= 500 && uiState != .wide {
            viewModel!.changeUIstate(to: .wide)
        
            self.mainView?.firstStackView.orientation = .horizontal
            self.mainView?.secondStackView.orientation = .horizontal
            
        } else if width <= 300 && uiState != .narrow {
            viewModel!.changeUIstate(to: .narrow)
            
            self.mainView?.firstStackView.orientation = .vertical
            self.mainView?.secondStackView.orientation = .vertical
            
        } else if width > 300 && width < 500 && uiState != .medium {
            viewModel!.changeUIstate(to: .medium)

            self.mainView?.firstStackView.orientation = .horizontal
            self.mainView?.secondStackView.orientation = .vertical

        }
        
    }
    
}
