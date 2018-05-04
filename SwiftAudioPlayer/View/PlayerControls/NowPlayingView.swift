//
//  NowPlayingView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol NowPlayingDelegate {
    func updateLabels()
}

class NowPlayingView: NSView {
    
    var delegate: NowPlayingDelegate?
    
    var title: String = "" {
        didSet { titleLabel.stringValue = title }
    }
    
    var artist: String = "" {
        didSet { artistLabel.stringValue = artist }
    }
    
    private let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 2
        stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.setContentHuggingPriority(.required, for: .horizontal)
        return stack
    }()
    
    private let titleLabel: Label = {
        let label = Label()
        label.stringValue = "Title"
        return label
    }()
    
    private let artistLabel: Label = {
        let label = Label()
        label.stringValue = "Artist"
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
        
        stackView.addArrangedSubview(artistLabel)
        stackView.addArrangedSubview(titleLabel)
    }
}
