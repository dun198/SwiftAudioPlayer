//
//  ProgressView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol ProgressDelegate {
    func updateDurationLabel()
    func updateCurrentPositionLabel()
    func seek()
}

class ProgressView: NSView {
    
    var delegate: ProgressDelegate?
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 8
        stack.edgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        stack.setHuggingPriority(.required, for: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let progressSlider: NSSlider = {
        let slider = NSSlider()
        slider.controlSize = NSControl.ControlSize.mini
        return slider
    }()
    
    let currentPositionLabel: Label = {
        let label = Label()
        label.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        label.stringValue = "00:00"
        return label
    }()
    
    let durationLabel: Label = {
        let label = Label()
        label.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        label.stringValue = "00:00"
        return label
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.fill(to: self)
        
        progressSlider.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        let centerViews: [NSView] = [currentPositionLabel, progressSlider, durationLabel]
        let leadingViews: [NSView] = []
        let trailingViews: [NSView] = []
        
        centerViews.forEach { stackView.addView($0, in: .center) }
        leadingViews.forEach { stackView.addView($0, in: .leading) }
        trailingViews.forEach { stackView.addView($0, in: .trailing) }
        
    }
}
