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
    setupTrackingArea()
  }
  
  private func setupView() {
    if #available(macOS 10.14, *) {
      material = .contentBackground
      blendingMode = .withinWindow
      backgroundFilters = [blurFilter!]
      blurFilter?.isEnabled = false
    }
  }
  
  private func setupTrackingArea() {
    addTrackingArea(NSTrackingArea(rect: frame, options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect], owner: self, userInfo: nil))
  }
  
  override func mouseEntered(with event: NSEvent) {
    print("entered")
    blurFilter?.isEnabled = true
  }
  
  override func mouseExited(with event: NSEvent) {
    blurFilter?.isEnabled = false
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
