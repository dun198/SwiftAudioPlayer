//
//  MainWindowController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 06.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate enum ToolbarItems: String {
  case toggleSidebar
  case addTracks
  case clearPlaylist
  case search
}

extension NSToolbarItem.Identifier {
  static let sidebar = NSToolbarItem.Identifier(rawValue: "toggleSidebarToolbarItem")
  static let parentDirectory = NSToolbarItem.Identifier(rawValue: "parentDirectoryToolbarItem")
  static let addTracks = NSToolbarItem.Identifier(rawValue: "addTracksToolbarItem")
  static let clearPlaylist = NSToolbarItem.Identifier(rawValue: "clearPlaylistToolbarItem")
  static let search = NSToolbarItem.Identifier(rawValue: "searchToolbarItem")
}

struct ToolbarItemConfiguration {
  let title: String
  let iconName: NSImage.Name
  let identifier: NSToolbarItem.Identifier
  let selector: Selector?
}

class MainWindowController: NSWindowController {
  
  var observer: NSKeyValueObservation?
  
  lazy var splitViewController: MainSplitViewController = {
    let vc = MainSplitViewController()
    vc.sidebarDelegate = self
    return vc
  }()
  
  let toolbarItems: [ToolbarItemConfiguration] = [
    ToolbarItemConfiguration(title: "Toggle Sidebar", iconName: NSImage.touchBarSidebarTemplateName, identifier: .sidebar, selector: #selector(handleToggleSidebar)),
    ToolbarItemConfiguration(title: "Add Tracks", iconName: NSImage.touchBarAddTemplateName, identifier: .addTracks, selector: #selector(handleAddTracks)),
    ToolbarItemConfiguration(title: "Clear Playlist", iconName: NSImage.touchBarDeleteTemplateName, identifier: .clearPlaylist, selector: #selector(handleClearPlaylist)),
    ToolbarItemConfiguration(title: "Search", iconName: NSImage.touchBarSearchTemplateName, identifier: .search, selector: #selector(handleSearch))
  ]
  
  var toolbarItemIdentifiers: [NSToolbarItem.Identifier] {
    var identifiers = toolbarItems.compactMap { $0.identifier }
    let standardIdentifiers: [NSToolbarItem.Identifier] = [.flexibleSpace, .space]
    identifiers.insert(contentsOf: standardIdentifiers, at: 0)
    return identifiers
  }
  
  override func loadWindow() {
    super.loadWindow()
    setupWindow()
    setupToolbar()
    setupObserver()
  }
  
  private func setupObserver() {
    observer = UserDefaults.standard.observe(\.colorScheme, options: [.initial, .new], changeHandler: { (defaults, change) in
      guard let colorSchemeName = change.newValue else { return }
      let colorScheme: Preferences.ColorScheme = Preferences.ColorScheme(rawValue: colorSchemeName) ?? .system
      var appearance: NSAppearance?
      switch colorScheme {
      case .system:
        appearance = nil
      case .dark:
        appearance = NSAppearance(named: .vibrantDark)
      case .light:
        appearance = NSAppearance(named: .vibrantLight)
      }
      for window in NSApp.windows {
        window.appearance = appearance
      }
    })
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
  }
  
  private func setupWindow() {
    window = NSWindow(contentViewController: splitViewController)
    
    guard let window = window else { fatalError() }
    window.delegate = self
    window.contentView = splitViewController.view

    window.title = "SwiftAudioPlayer"
    window.setFrameAutosaveName("MainWindow")
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.isMovableByWindowBackground = true
    window.styleMask.insert([.fullSizeContentView])
    window.toolbar = NSToolbar(identifier: NSToolbar.Identifier.init("MainToolbar"))
    window.makeKeyAndOrderFront(nil)
    window.contentView?.addTrackingArea(NSTrackingArea(rect: NSRect(x: window.frame.maxX, y: window.frame.minY, width: window.frame.width, height: 48), options: [.activeAlways, .mouseEnteredAndExited, .mouseMoved], owner: self, userInfo: nil))
  }
  
  private func setupToolbar() {
    guard let toolbar = window?.toolbar else { return }
    toolbar.autosavesConfiguration = true
    toolbar.showsBaselineSeparator = false
    toolbar.allowsUserCustomization = true
    toolbar.isVisible = true
    toolbar.delegate = self
    
    if let items = toolbar.visibleItems, items.isEmpty {
      toolbar.insertItem(withItemIdentifier: .sidebar, at: 0)
      toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 1)
      toolbar.insertItem(withItemIdentifier: .addTracks, at: 2)
      toolbar.insertItem(withItemIdentifier: .clearPlaylist, at: 3)
      toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 4)
      toolbar.insertItem(withItemIdentifier: .search, at: 5)
    }
  }
}

extension MainWindowController: NSToolbarDelegate {
  
  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return self.toolbarItemIdentifiers;
  }
  
  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return self.toolbarDefaultItemIdentifiers(toolbar)
  }
  
  func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return self.toolbarDefaultItemIdentifiers(toolbar)
  }
  
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    
    guard let item: ToolbarItemConfiguration = toolbarItems.first(where: {$0.identifier == itemIdentifier})
      else { fatalError() }
    
    let toolbarItem: NSToolbarItem
    toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
    toolbarItem.label = item.title
    toolbarItem.paletteLabel = item.title
    
    let image = NSImage(named: item.iconName)
    let button = ImageButton(image: image!, width: 24, height: 24, scaling: NSImageScaling.scaleProportionallyUpOrDown)
    button.isBordered = true
    button.bezelStyle = .texturedRounded
    button.target = self
    button.action = item.selector
    
    toolbarItem.view = button
    return toolbarItem
  }
  
  func toolbarWillAddItem(_ notification: Notification) {
    // Make sure that tracking is evaluated only after the item was added
    DispatchQueue.main.async {
      self.trackSplitViewForFirstFlexibleToolbarItem()
    }
  }
  
  func toolbarDidRemoveItem(_ notification: Notification) {
    DispatchQueue.main.async {
      self.trackSplitViewForFirstFlexibleToolbarItem()
    }
  }
  
  /// - Warning: This is a private Apple method and may break in the future.
  func toolbarDidReorderItem(_ notification: Notification) {
    DispatchQueue.main.async {
      self.trackSplitViewForFirstFlexibleToolbarItem()
    }
  }
  
  /// - Warning: This method uses private Apple methods that may break in the future.
  fileprivate func trackSplitViewForFirstFlexibleToolbarItem() {
    guard var toolbarItems = self.window?.toolbar?.items, let splitView = (contentViewController as? NSSplitViewController)?.splitView else {
      return
    }
    
    // Add tracking to the first flexible space and remove it from the group
    var flexibleToolbarIndexes: [Int?] = []
    for i in 0 ..< toolbarItems.count {
      if toolbarItems[i].itemIdentifier == .flexibleSpace {
        flexibleToolbarIndexes.append(i)
      }
    }
    
    if let firstFlexibleToolbarItemIndex = toolbarItems.firstIndex(where: {$0.itemIdentifier == .flexibleSpace}) {
      toolbarItems[firstFlexibleToolbarItemIndex].perform(Selector(("setTrackedSplitView:")), with: splitView)
      toolbarItems.remove(at: firstFlexibleToolbarItemIndex)
    }
    
    // Remove tracking from other flexible spaces
    for flexibleToolbarItem in toolbarItems.filter({ $0.itemIdentifier == NSToolbarItem.Identifier.flexibleSpace}) {
      _ = flexibleToolbarItem.perform(Selector(("setTrackedSplitView:")), with: nil)
    }
  }
}

extension MainWindowController: NSWindowDelegate {
  
  // hide the toolbar when in fullscreen mode
  func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
    var presOptions: NSApplication.PresentationOptions = [proposedOptions]
    presOptions.insert(.autoHideToolbar)
    return presOptions
  }
  
  func windowDidEnterFullScreen(_ notification: Notification) {
  }
  
  func windowWillEnterFullScreen(_ notification: Notification) {
    NotificationCenter.default
      .post(name:Notification.Name(
        rawValue:"windowWillEnterFullscreenNotification"),
            object: nil,
            userInfo: nil)
  }
  
  func windowWillExitFullScreen(_ notification: Notification) {
    NotificationCenter.default
      .post(name:Notification.Name(
        rawValue:"windowWillExitFullscreenNotification"),
            object: nil,
            userInfo: nil)
  }
  
  func windowDidExitFullScreen(_ notification: Notification) {
  }
}

extension MainWindowController {
  @objc private func handleToggleSidebar() {
    print("pressed toggleToolbarButton")
    splitViewController.toggleSidebar(nil)
  }
  
  @objc private func handleAddTracks() {
    print("pressed addTracksButton")
    splitViewController.contentVC.addTracks()
  }
  
  @objc private func handleClearPlaylist() {
    print("pressed clearPlaylistButton")
    splitViewController.contentVC.removeAllTracks()
  }
  
  @objc private func handleSearch() {
    print("pressed SearchButton")
  }
}

extension MainWindowController: SidebarDelegate {
  func sidebarDidToggle() {
    DispatchQueue.main.async {
      self.trackSplitViewForFirstFlexibleToolbarItem()
    }
  }
}
