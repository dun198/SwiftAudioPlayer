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
    
    var cornerRadius: CGFloat = 0 {
        didSet{ needsDisplay = true }
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
    }
    
    override func updateLayer() {
        super.updateLayer()
        layer?.cornerRadius = cornerRadius
    }
}
