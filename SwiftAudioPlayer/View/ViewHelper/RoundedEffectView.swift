//
//  RoundedEffectView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class RoundedEffectView: NSVisualEffectView {
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var cornerRadius: CGFloat = 6 {
    didSet{
      needsDisplay = true
    }
  }
  
  func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    blendingMode = .withinWindow
    if #available(OSX 10.14, *) {
      material = .headerView
    } else {
      material = .appearanceBased
    }
    wantsLayer = true
    //layer?.backgroundColor = CGColor(gray: 1, alpha: 0.2)
    layer?.borderColor = CGColor(gray: 0, alpha: 0.1)
    layer?.borderWidth = 0.25
    state = .active
  }
  
  override func updateLayer() {
    super.updateLayer()
    layer?.cornerRadius = cornerRadius
  }
}
