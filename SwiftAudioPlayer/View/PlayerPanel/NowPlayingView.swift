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
    
    let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 2
        stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.setContentHuggingPriority(.required, for: .horizontal)
//        stack.setHuggingPriority(.required, for: .horizontal)
//        stack.setClippingResistancePriority(.required, for: .horizontal)
//        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stack
    }()
    
    var title: String = "" {
        didSet {
            titleLabel.stringValue = title
        }
    }
    
    var artist: String = "" {
        didSet {
            artistLabel.stringValue = artist
        }
    }
    
    private let titleLabel: Label = {
        let label = Label()
        label.stringValue = "Title"
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: Label = {
        let label = Label()
        label.stringValue = "Artist"
        //label.translatesAutoresizingMaskIntoConstraints = false
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
        
//        addSubview(titleLabel)
//        addSubview(artistLabel)
//
//        // titleLabel
//        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
//
//        // artistLabel
//        artistLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
//        artistLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
