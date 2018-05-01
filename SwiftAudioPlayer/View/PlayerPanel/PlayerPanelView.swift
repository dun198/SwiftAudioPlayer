//
//  PlayerPanelView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class PlayerPanelView: RoundedShadowedBox {
    
    // player controls
    lazy var playerControlsView: PlaybackControlsView = {
        let view = PlaybackControlsView()
        view.isHidden = true
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
    
    //    let visualEffectView: NSVisualEffectView = {
    //        let view = NSVisualEffectView()
    //        view.material = .ultraDark
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        view.blendingMode = NSVisualEffectView.BlendingMode.withinWindow
    //        view.wantsLayer = true
    //        view.layer?.cornerRadius = 16
    //        return view
    //    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupViews()
        
        // add tracking area
        addTrackingArea(NSTrackingArea(rect: self.bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
//        addSubview(visualEffectView)
        addSubview(playerControlsView)
        addSubview(progressView)
        addSubview(nowPlayingView)
        
//        visualEffectView.fill(to: self)
        
        playerControlsView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        playerControlsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        playerControlsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        nowPlayingView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        nowPlayingView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nowPlayingView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nowPlayingView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        progressView.topAnchor.constraint(equalTo: playerControlsView.bottomAnchor, constant: 0).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        progressView.heightAnchor.constraint(equalToConstant: 16).isActive = true
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
