//
//  PlayerWindowController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBAction func toggleUIAction(_ sender: Any) {
        toggleAppearance()
    }
    
    @IBAction func toggleSidebar(_ sender: Any) {
        mainVC.toggleSidebar(sender) { [weak self] in
            print("track flexible toolbar item")
            guard let view = self?.mainVC.view else { return }
            view.setNeedsDisplay(view.frame)
        }
    }
    
    let mainVC: MainViewController = {
        let vc = MainViewController()
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
        
        if let window = window {
            window.contentViewController = mainVC
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.styleMask.insert(.fullSizeContentView)
            //window.styleMask.insert(.texturedBackground)
            //window.toolbar?.showsBaselineSeparator = true
            window.toolbar?.delegate = self
            window.appearance = NSAppearance(named: .vibrantDark)
        }
        
        // Make sure that tracking is enabled when the toolbar is completed
        DispatchQueue.main.async {
            self.trackSplitViewForFirstFlexibleToolbarItem()
        }

        guard let viewModel = viewModel else { return }
        viewModel.colorScheme.bindAndFire { [unowned self] in
            self.colorScheme = $0
        }

    }

    func updateWindowState() {
        window?.update()
    }

    func toggleAppearance() {
        if !darkMode {
            self.window?.appearance = NSAppearance(named: .vibrantDark)
        } else {
            self.window?.appearance = NSAppearance(named: .vibrantLight)
        }
        darkMode = !darkMode
    }
}

extension MainWindowController: NSWindowDelegate {

    func windowWillEnterFullScreen(_ notification: Notification) {

    }

    func windowDidEnterFullScreen(_ notification: Notification) {

    }

    func windowWillExitFullScreen(_ notification: Notification) {

    }

    func windowDidExitFullScreen(_ notification: Notification) {
        
    }

    func windowDidResize(_ notification: Notification) {

    }

}

extension MainWindowController: NSToolbarDelegate {
    func toolbarWillAddItem(_ notification: Notification) {
        print("will add item")
        // Make sure that tracking is evaluated only after the item was added
        DispatchQueue.main.async {
            self.trackSplitViewForFirstFlexibleToolbarItem()
        }
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        print("removed item")
        trackSplitViewForFirstFlexibleToolbarItem()
    }
    
    /// - Warning: This is a private Apple method and may break in the future.
    func toolbarDidReorderItem(_ notification: Notification) {
        print("reordered item")
        trackSplitViewForFirstFlexibleToolbarItem()
    }
    
    /// - Warning: This method uses private Apple methods that may break in the future.
    fileprivate func trackSplitViewForFirstFlexibleToolbarItem() {
        guard var toolbarItems = self.window?.toolbar?.items, let splitView = (contentViewController as? NSSplitViewController)?.splitView else {
            return
        }
        
        // Add tracking to the first flexible space and remove it from the group
        if let firstFlexibleToolbarItem = toolbarItems.first, firstFlexibleToolbarItem.itemIdentifier == NSToolbarItem.Identifier.flexibleSpace {
            _ = firstFlexibleToolbarItem.perform(Selector(("setTrackedSplitView:")), with: splitView)
            toolbarItems.removeFirst()
        }
        
        // Remove tracking from other flexible spaces
        for flexibleToolbarItem in toolbarItems.filter({ $0.itemIdentifier == NSToolbarItem.Identifier.flexibleSpace }) {
            _ = flexibleToolbarItem.perform(Selector(("setTrackedSplitView:")), with: nil)
        }
    }
    
    func didToggleSidebar() {
        trackSplitViewForFirstFlexibleToolbarItem()
    }
}
