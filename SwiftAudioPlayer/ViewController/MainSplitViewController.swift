//
//  MainSplitViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let sidebarMinWidth: CGFloat = 150
fileprivate let sidebarMaxWidth: CGFloat = 250

fileprivate let contentMinWidth: CGFloat = 250

fileprivate let infoBarMinWidth: CGFloat = 200
fileprivate let infoBarMaxWidth: CGFloat = 200

fileprivate let showHideInterfaceThreshold: CGFloat = 5

protocol SidebarDelegate {
  func sidebarDidToggle()
}

class MainSplitViewController: NSSplitViewController {
  
  var sidebarDelegate: SidebarDelegate?
  let player = Player()
  
  let contentVC: ContentViewController = {
    let vc = ContentViewController()
    return vc
  }()
  
  let sidebarVC: SidebarViewController = {
    let vc = SidebarViewController()
    return vc
  }()
  
  let infoBarVC: SidebarViewController = {
    let vc = SidebarViewController()
    return vc
  }()
  
  lazy var contentSplitItem: NSSplitViewItem = {
    let item = NSSplitViewItem(viewController: contentVC)
    item.minimumThickness = contentMinWidth
    return item
  }()
  
  lazy var sidebarSplitItem: CollapsibleSplitItem = {
    let item = CollapsibleSplitItem(sidebarWithViewController: sidebarVC)
    item.minimumThickness = sidebarMinWidth
    item.maximumThickness = sidebarMaxWidth
    return item
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.wantsLayer = false
    setupSplitView()
    
    view.addTrackingArea(NSTrackingArea(rect: NSScreen.main!.frame, options: [.activeAlways, .mouseMoved, .mouseEnteredAndExited], owner: self, userInfo: nil))
  }
  
  override func toggleSidebar(_ sender: Any?) {
    super.toggleSidebar(sender)
    sidebarDelegate?.sidebarDidToggle()
  }
  
  private func setupSplitView() {
    addSplitViewItem(sidebarSplitItem)
    addSplitViewItem(contentSplitItem)
  }
  
  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
    contentVC.fadeControls()
  }
  
  override func mouseEntered(with event: NSEvent) {
    super.mouseEntered(with: event)
    contentVC.showControls()
  }
  
  override func mouseMoved(with event: NSEvent) {
    super.mouseMoved(with: event)
    let yVelocity = abs(event.deltaY)
    let xVelocity = abs(event.deltaX)
    if yVelocity >= showHideInterfaceThreshold || xVelocity >= showHideInterfaceThreshold * 2{
      contentVC.showControls()
    }
  }
}
