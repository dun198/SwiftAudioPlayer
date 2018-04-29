//
//  PlayerWindowController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBAction func toggleUI(_ sender: Any) {
        toggleAppearance()
    }
    
    @IBAction func toggleSidebar(_ sender: Any) {
        mainVC.toggleSidebar(sender) {
            print("track flexible toolbar item")
        }
    }
    
    let mainVC: MainSplitViewController = {
        let vc = MainSplitViewController()
        return vc
    }()
    
    var darkMode = true
    var bypassDidResize = false
    var colorScheme: ColorScheme = ColorScheme.dark {
        didSet {
            //toggleAppearance()
        }
    }

    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        viewModel = ViewModel()
        
        setupWindow()
        
        guard let viewModel = viewModel else { return }
        viewModel.colorScheme.bindAndFire { [unowned self] in
            self.colorScheme = $0
        }

    }

    private func setupWindow() {
        if let window = window {
            window.contentViewController = mainVC
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.styleMask.insert(.fullSizeContentView)
            window.appearance = NSAppearance(named: .vibrantDark)
            window.toolbar?.showsBaselineSeparator = false
        }
    }
    
    private func updateWindowState() {
        window?.update()
    }

    private func toggleAppearance() {
        if !darkMode {
            self.window?.appearance = NSAppearance(named: .vibrantDark)
        } else {
            self.window?.appearance = NSAppearance(named: .vibrantLight)
        }
        darkMode = !darkMode
    }
}

extension MainWindowController: NSWindowDelegate {
    
    func windowWillEnterFullScreen(_ notification: Notification) {}
    func windowDidEnterFullScreen(_ notification: Notification) {}
    func windowWillExitFullScreen(_ notification: Notification) {}
    func windowDidExitFullScreen(_ notification: Notification) {}
    func windowDidResize(_ notification: Notification) {}
    
}


