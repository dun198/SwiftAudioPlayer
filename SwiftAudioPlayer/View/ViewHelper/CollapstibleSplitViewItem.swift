//
//  CollapstibleSplitViewItem.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 30.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol CollapseSplitViewDelegate {
  func splitView(didCollapse: Bool)
}

class CollapsibleSplitItem: NSSplitViewItem {
  
  var delegate: CollapseSplitViewDelegate?
  
  override var isCollapsed: Bool {
    didSet {
      delegate?.splitView(didCollapse: isCollapsed)
    }
  }
}
