//
//  TitleView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 04.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class RoundedEffectViewLabel: RoundedEffectView {
  
  var text: String? {
    didSet { label.stringValue = text ?? "" }
  }
  
  let label: Label = {
    let label = Label()
    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    return label
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    addSubview(label)
    label.fill(to: self, with: NSEdgeInsets(top: 4, left: 8, bottom: -4, right: -8))
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
