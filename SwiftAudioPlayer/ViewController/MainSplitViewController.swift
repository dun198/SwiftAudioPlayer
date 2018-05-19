//
//  MainSplitViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let sidebarMinWidth: CGFloat = 200
fileprivate let sidebarMaxWidth: CGFloat = 200

fileprivate let contentMinWidth: CGFloat = 250

fileprivate let infoBarMinWidth: CGFloat = 200
fileprivate let infoBarMaxWidth: CGFloat = 200

class MainSplitViewController: NSSplitViewController {
  
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
    item.delegate = contentVC.toolbarView
    return item
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.wantsLayer = false
    setupSplitView()
  }
  
//  func toggleSidebar(_ sender: Any?, withCompletionHandler completion:@escaping () -> Void) {
//    toggleSidebar(sender)
//    view.setNeedsDisplay(view.frame)
//    completion()
//  }
  
  private func setupSplitView() {
    addSplitViewItem(sidebarSplitItem)
    addSplitViewItem(contentSplitItem)
  }
}

//class CustomSidebarSplitViewItem: NSSplitViewItem {
//    convenience init(withViewController viewController: NSViewController) {
//        self.init(viewController: viewController)
//        self.maximumThickness = 200
//        self.minimumThickness = 200
//        self.canCollapse = true
//        self.isSpringLoaded = true
//        self.collapseBehavior = .useConstraints
//        self.holdingPriority = .defaultLow
//    }
//}
