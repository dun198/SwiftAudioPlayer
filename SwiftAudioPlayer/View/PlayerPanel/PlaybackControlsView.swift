//
//  PlaybackControlsView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol PlaybackControlsDelegate {
    func playPause(sender: Any)
    func next(sender: Any)
    func prev(sender: Any)
}

class PlaybackControlsView: NSView {
    
    var delegate: PlaybackControlsDelegate?
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 8
        stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.setContentHuggingPriority(NSLayoutConstraint.Priority.dragThatCannotResizeWindow, for: .horizontal)
        stack.setClippingResistancePriority(.defaultLow, for: .horizontal)
//        stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stack
    }()
    
    lazy var playPauseButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarPlayTemplate)
        let scaling = NSImageScaling.scaleProportionallyUpOrDown
        let button = ImageButton(image: image!, width: 40, height: 40, scaling: scaling)
        button.target = self
        button.action = #selector(playPause)
        return button
    }()
    
    lazy var prevButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarSkipBackTemplate)
        let button = ImageButton(image: image!)
        button.target = self
        button.action = #selector(prev)
        return button
    }()
    
    lazy var nextButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarSkipAheadTemplate)
        let button = ImageButton(image: image!)
        button.target = self
        button.action = #selector(next)
        return button
    }()
    
    lazy var shuffleButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarShareTemplate)
        let button = ImageButton(image: image!, width: 24, height: 24)
        button.target = self
        return button
    }()
    
    lazy var repeatButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarRefreshTemplate)
        let button = ImageButton(image: image!, width: 24, height: 24)
        button.target = self
        return button
    }()
    
    lazy var volumeButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarAudioOutputVolumeHighTemplate)
        let button = ImageButton(image: image!, width: 24, height: 24)
        button.target = self
        return button
    }()
    
    lazy var infoButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarGetInfoTemplate)
        let button = ImageButton(image: image!, width: 24, height: 24)
        button.target = self
        return button
    }()
    
    lazy var leadingViews: [NSView] = [
        shuffleButton,
        repeatButton,
        SpacerView(minSize: 16, maxSize: 64)
    ]
    lazy var centerViews: [NSView] = [
        prevButton,
        playPauseButton,
        nextButton
    ]
    lazy var trailingViews: [NSView] = [
        SpacerView(minSize: 16, maxSize: 64),
        volumeButton,
        infoButton
    ]
    
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
        
        leadingViews.forEach {
            stackView.addView($0, in: .leading)
            stackView.setVisibilityPriority(NSStackView.VisibilityPriority.detachOnlyIfNecessary, for: $0)
        }
        centerViews.forEach {
            stackView.addView($0, in: .center)
            stackView.setVisibilityPriority(NSStackView.VisibilityPriority.mustHold, for: $0)
        }
        trailingViews.forEach {
            stackView.addView($0, in: .trailing)
            stackView.setVisibilityPriority(NSStackView.VisibilityPriority.detachOnlyIfNecessary, for: $0)
        }
    }
    
    @objc private func playPause() {
        delegate?.playPause(sender: playPauseButton)
    }
    
    @objc private func next() {
        delegate?.next(sender: nextButton)
    }
    
    @objc private func prev() {
        delegate?.prev(sender: prevButton)
    }
}
