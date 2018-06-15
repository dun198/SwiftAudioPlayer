//
//  Label.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class Label: NSTextField {
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    
    isEditable = false
    isBordered = false
    isBezeled = false
    usesSingleLineMode = true
    drawsBackground = false
    autoresizesSubviews = true
    cell?.truncatesLastVisibleLine = true
    cell?.lineBreakMode = .byTruncatingMiddle
    translatesAutoresizingMaskIntoConstraints = false
    textColor = .labelColor
    
    //        setContentHuggingPriority(.defaultLow, for: .horizontal)
    //        setContentHuggingPriority(.defaultLow, for: .vertical)
    //        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    //        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
