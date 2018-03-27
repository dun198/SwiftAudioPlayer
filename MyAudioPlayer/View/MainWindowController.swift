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
    var bypassDidResize = false
    
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
    lazy var nowPlayingVC: NowPlayingViewController? = nil
    lazy var playerControlsVC: PlayerControlsViewController? = nil
    lazy var progressVC: ProgressViewController? = nil


    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.appearance = NSAppearance(named: .vibrantDark)
        self.window?.isOpaque = true
        self.window?.titleVisibility = .hidden
        
        setupTitlebar()

        
        viewModel = ViewModel()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
    }
    
    func setupTitlebar() {
        
        if let nowPlayingVC = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "nowPlayingVC")) as? NowPlayingViewController {
            
            nowPlayingVC.layoutAttribute = .bottom
            nowPlayingVC.fullScreenMinHeight = 50
            
            // layoutAttribute has to be set before added to window
            self.window?.addTitlebarAccessoryViewController(nowPlayingVC)
        }
        
        nowPlayingVC = self.window?.titlebarAccessoryViewControllers[0] as? NowPlayingViewController

        if let playerControlsVC = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "playerControlsVC")) as? PlayerControlsViewController {
            
            playerControlsVC.layoutAttribute = .bottom
            
            // layoutAttribute has to be set before added to window
            self.window?.addTitlebarAccessoryViewController(playerControlsVC)
        }
        
        playerControlsVC = self.window?.titlebarAccessoryViewControllers[1] as? PlayerControlsViewController
        
        if let progressVC = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "progressVC")) as? ProgressViewController {
            
            progressVC.layoutAttribute = .bottom
            
            // layoutAttribute has to be set before added to window
            self.window?.addTitlebarAccessoryViewController(progressVC)
        }
        
        progressVC = self.window?.titlebarAccessoryViewControllers[2] as? ProgressViewController
        
        
        
//        let nowPlayingVC = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "NowPlayingVC"))
        
        
    }
    
    func updateWindowState() {
        window?.update()
        guard let width = self.window?.frame.width,
            let uiState = viewModel?.uiState.value else { return }
        
        print(width)
        
        if width >= 500 && uiState != .wide {
            viewModel!.changeUIstate(to: .wide)
            
            nowPlayingVC?.layoutAttribute = .bottom
            progressVC?.layoutAttribute = .bottom
            playerControlsVC?.layoutAttribute = .bottom
            
            //            titlebarController.titlebarView.setFrameSize(NSSize(width: width, height: 50))
            //            titlebarController.firstStackView.orientation = .horizontal
            //            titlebarController.secondStackView.orientation = .horizontal
            
        } else if width <= 300 && uiState != .narrow {
            viewModel!.changeUIstate(to: .narrow)
            
            //            titlebarController.titlebarView.setFrameSize(NSSize(width: width, height: 125))
            //            titlebarController.firstStackView.orientation = .vertical
            //            titlebarController.secondStackView.orientation = .vertical
            
        } else if width > 300 && width < 500 && uiState != .medium {
            viewModel!.changeUIstate(to: .medium)
            
            //            titlebarController.titlebarView.setFrameSize(NSSize(width: width, height: 80))
            //            titlebarController.firstStackView.orientation = .horizontal
            //            titlebarController.secondStackView.orientation = .vertical
            
        }
    }
    
}

extension MainWindowController: NSWindowDelegate {
    
    func windowWillEnterFullScreen(_ notification: Notification) {
        bypassDidResize = true

    }
    
    func windowDidEnterFullScreen(_ notification: Notification) {
        bypassDidResize = false
        updateWindowState()
        
        //self.window?.styleMask.insert(.texturedBackground)
        
    }
    
    func windowWillExitFullScreen(_ notification: Notification) {
        bypassDidResize = true

        //self.window?.styleMask.remove(.texturedBackground)
        
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        bypassDidResize = false
        
    }
    
    func windowDidResize(_ notification: Notification) {
        guard !bypassDidResize else { return }
        updateWindowState()
    }
    
}
