//
//  ToolbarBackgroundView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 06.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ToolbarBackgroundView: NSVisualEffectView {
  
  let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius" : 10])
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
    addTrackingArea(NSTrackingArea(rect: self.frame, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
  }
  
  private func setupView() {
    if #available(macOS 10.14, *) {
      material = .contentBackground
      blendingMode = .withinWindow
      backgroundFilters = [blurFilter!]
      blurFilter?.isEnabled = false
    }
  }
  
  override func mouseDown(with event: NSEvent) {
  }
  
  override func mouseExited(with event: NSEvent) {
    isHidden = true
  }
  
  override func mouseEntered(with event: NSEvent) {
    isHidden = false
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
