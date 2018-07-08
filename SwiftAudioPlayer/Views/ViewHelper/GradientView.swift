//
//  GradientView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 02.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class GradientView: NSView {
  
  var topGradientColor: NSColor = .clear {
    didSet { updateLayer() }
  }
  var bottomGradientColor: NSColor = .clear {
    didSet { updateLayer() }
  }
  var bottomColorLocation: NSNumber = 0 {
    didSet { updateLayer() }
  }
  var topColorLocation: NSNumber = 1 {
    didSet { updateLayer() }
  }
  
  lazy var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [bottomGradientColor.cgColor, topGradientColor.cgColor]
    layer.locations = [bottomColorLocation, topColorLocation]
    return layer
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    wantsLayer = true
    self.layer = gradientLayer
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateLayer() {
    updateGradientLayer()
    super.updateLayer()
    print("gradientLayer updated")
  }
  
  private func updateGradientLayer() {
    print("updateGradientLayer()")
    gradientLayer.colors = [bottomGradientColor.cgColor, topGradientColor.cgColor]
    gradientLayer.locations = [bottomColorLocation, topColorLocation]
  }
}


