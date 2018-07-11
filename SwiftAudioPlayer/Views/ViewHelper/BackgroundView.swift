//
//  BackgroundView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class BackgroundView: NSView {
  
  var backgroundColor: NSColor? {
    didSet {
      updateLayer()
    }
  }
  
  var cornerRadius: CGFloat? {
    didSet {
      updateLayer()
    }
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func updateLayer() {
    super.updateLayer()
    layer?.backgroundColor = backgroundColor?.cgColor
    layer?.cornerRadius = cornerRadius ?? 0.0
  }
  
}
