//
//  PlayerPanel.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class PlayerPanel: NSView {
    
    // background effect view
    let backgroundEffectView: NSVisualEffectView = {
        let view = NSVisualEffectView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 6
        view.layer?.masksToBounds = true
        view.layer?.borderWidth = 0.4
        view.layer?.borderColor = CGColor(gray: 0, alpha: 0.2)
        view.blendingMode = NSVisualEffectView.BlendingMode.withinWindow
        view.state = NSVisualEffectView.State.active
        return view
    }()
    
    // player controls
    lazy var playerControlsView: PlaybackControlsView = {
        let view = PlaybackControlsView()
        view.isHidden = true
//        view.alphaValue = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = PlaybackControlsViewController()
        return view
    }()
    
    // progress bar
    lazy var progressView: ProgressBarView = {
        let view = ProgressBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // now playing info
    lazy var nowPlayingView: NowPlayingView = {
        let view = NowPlayingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addShadow()
        setupViews()
        
        // add tracking area
        addTrackingArea(NSTrackingArea(rect: self.bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addShadow() {
        shadow = NSShadow()
        shadow?.shadowBlurRadius = 4
        shadow?.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.2)
        shadow?.shadowOffset = CGSize(width: 1, height: -2)
    }
    
    private func setupViews() {
        addSubview(backgroundEffectView)
        backgroundEffectView.fill(to: self)

        backgroundEffectView.addSubview(progressView)
        backgroundEffectView.addSubview(playerControlsView)
        backgroundEffectView.addSubview(nowPlayingView)
        
        playerControlsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        playerControlsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        playerControlsView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        playerControlsView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -4).isActive = true
        
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        nowPlayingView.centerYAnchor.constraint(equalTo: playerControlsView.centerYAnchor, constant: 0).isActive = true
        nowPlayingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true        
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("mouseEntered()")
        nowPlayingView.isHidden = true
        playerControlsView.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        print("mouseExited()")
        nowPlayingView.isHidden = false
        playerControlsView.isHidden = true
    }
}
