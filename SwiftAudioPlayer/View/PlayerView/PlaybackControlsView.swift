//
//  PlaybackControlsView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol PlayerControlsDelegate {
    func playPause(sender: Any)
    func next(sender: Any)
    func prev(sender: Any)
}

class PlaybackControlsView: NSView {
    
    var delegate: PlayerControlsDelegate?
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 0
        stack.edgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setContentHuggingPriority(.required, for: .horizontal)
        stack.setClippingResistancePriority(.required, for: .horizontal)
        stack.setHuggingPriority(.defaultLow, for: .horizontal)
        return stack
    }()
    
    lazy var playPauseButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarPlayTemplate)
        let size = NSSize(width: 48, height: 48)
        let button = ImageButton(image: image!, size: size)
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
        let image = NSImage(named: NSImage.Name.touchBarRotateLeftTemplate)
        let button = ImageButton(image: image!)
        button.target = self
        return button
    }()
    
    lazy var repeatButton: ImageButton = {
        let image = NSImage(named: NSImage.Name.touchBarRefreshTemplate)
        let button = ImageButton(image: image!)
        button.target = self
        return button
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
        
        let leadingViews: [NSView] = []
        let centerViews: [NSView] = [prevButton, playPauseButton, nextButton]
        let trailingViews: [NSView] = []

        leadingViews.forEach { stackView.addView($0, in: .leading) }
        centerViews.forEach { stackView.addView($0, in: .center) }
        trailingViews.forEach { stackView.addView($0, in: .trailing) }
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
