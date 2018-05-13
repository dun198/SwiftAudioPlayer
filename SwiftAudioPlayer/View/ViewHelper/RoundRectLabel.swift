//
//  RoundRectLabel.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class RoundRectLabel: Label {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    
    isBordered = true
    textColor = .white
    
    wantsLayer = true
    layer?.masksToBounds = true
    layer?.backgroundColor = NSColor.darkGray.cgColor
    layer?.cornerRadius = 4
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
