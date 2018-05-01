//
//  RoundedShadowedBox.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class RoundedShadowedBox: NSBox {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupBox()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundColor: NSColor = .clear {
        didSet {
            needsDisplay = true
        }
    }
    
    func setupBox() {
        boxType = .custom
        titlePosition = .noTitle
        borderType = .noBorder
        cornerRadius = 6
        borderWidth = 0
        isTransparent = false
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .controlBackgroundColor
        needsDisplay = true
    }
    
    override func updateLayer() {
        super.updateLayer()
        layer?.backgroundColor = backgroundColor.cgColor
        shadow = NSShadow()
        layer?.shadowOpacity = 0.2
        layer?.shadowRadius = 5
        layer?.shadowOffset = .init(width: 2, height: -2)
        layer?.shadowColor = NSColor.black.cgColor
    }
}
