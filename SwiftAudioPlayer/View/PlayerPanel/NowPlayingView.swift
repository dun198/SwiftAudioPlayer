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
        addSubview(titleLabel)
        addSubview(artistLabel)
       
        // titleLabel
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        // artistLabel
        artistLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        artistLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
