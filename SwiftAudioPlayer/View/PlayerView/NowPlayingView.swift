//
//  NowPlayingView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class NowPlayingView: NSView {
    
    let titleLabel: Label = {
        let label = Label()
        label.stringValue = "Title"
        return label
    }()
    
    let artistLabel: Label = {
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
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            artistLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            artistLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        
    }
}
