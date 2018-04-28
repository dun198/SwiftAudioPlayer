//
//  PlayerControlsView.swift
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

class PlayerControlsView: NSView {
    
    var delegate: PlayerControlsDelegate?
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 0
        stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var playPauseButton: ImageButton = {
        let button = ImageButton()
        button.image = NSImage(named: NSImage.Name.touchBarPlayTemplate)
        button.target = self
        button.action = #selector(playPause)
        return button
    }()
    
    lazy var prevButton: ImageButton = {
        let button = ImageButton()
        button.image = NSImage(named: NSImage.Name.touchBarSkipBackTemplate)
        button.target = self
        button.action = #selector(prev)
        return button
    }()
    
    lazy var nextButton: ImageButton = {
        let button = ImageButton()
        button.image = NSImage(named: NSImage.Name.touchBarSkipAheadTemplate)
        button.target = self
        button.action = #selector(next)
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
        
        let centerViews: [NSView] = [prevButton, playPauseButton, nextButton]
        let leadingViews: [NSView] = []
        let trailingViews: [NSView] = []
        
        centerViews.forEach { stackView.addView($0, in: .center) }
        leadingViews.forEach { stackView.addView($0, in: .leading) }
        trailingViews.forEach { stackView.addView($0, in: .trailing) }

        prevButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        prevButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        playPauseButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
