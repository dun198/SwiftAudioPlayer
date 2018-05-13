//
//  MainWindowController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 06.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  var viewController: MainSplitViewController!
  
  var colorScheme: ColorScheme = ColorScheme.dark {
    didSet {
      setColorScheme(to: colorScheme)
    }
  }
  
  override func loadWindow() {
    super.loadWindow()
    setupWindow()
    window?.makeKeyAndOrderFront(nil)
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
  }
  
  private func setupWindow() {
    viewController = MainSplitViewController()
    window = NSWindow(contentViewController: viewController)
    
    guard let window = window else { fatalError() }
    window.delegate = self
    window.contentView = viewController.view
    
    window.title = "SwiftAudioPlayer"
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.isMovableByWindowBackground = true
    window.styleMask.insert([.fullSizeContentView])
    window.appearance = NSAppearance(named: .vibrantDark)
    window.toolbar = NSToolbar(identifier: NSToolbar.Identifier.init("MainToolbar"))
    window.toolbar?.showsBaselineSeparator = false
    window.toolbar?.allowsUserCustomization = false
    window.toolbar?.isVisible = true
  }
  
  private func setColorScheme(to colorScheme: ColorScheme) {
    var appearance: NSAppearance?
    switch colorScheme {
    case .dark:
      appearance = NSAppearance(named: .vibrantDark)
    case .light:
      appearance = NSAppearance(named: .vibrantLight)
    }
    self.window?.appearance = appearance
  }
}

extension MainWindowController: NSWindowDelegate {
  
  func windowDidEnterFullScreen(_ notification: Notification) {
  }
  
  func windowWillEnterFullScreen(_ notification: Notification) {
    window?.toolbar?.isVisible = false
  }
  
  func windowDidExitFullScreen(_ notification: Notification) {
    window?.toolbar?.isVisible = true
  }
}
