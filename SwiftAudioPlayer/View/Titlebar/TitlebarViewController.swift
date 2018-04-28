//
//  TitlebarViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 02.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class TitlebarViewController: NSTitlebarAccessoryViewController {
    
    let nowPlayingView: NSView = {
        let view = NowPlayingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var playerControlsView: NSView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // add tracking area
        view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil))

    }
    
    private func setupViews() {
        view.addSubview(nowPlayingView)
        
        NSLayoutConstraint.activate([
            nowPlayingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nowPlayingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            nowPlayingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            nowPlayingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        
        nowPlayingView.viewDidMoveToSuperview()
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("mouseEntered()")
        nowPlayingView.isHidden = true
        playerControlsView?.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        print("mouseExited()")
        nowPlayingView.isHidden = false
        playerControlsView?.isHidden = true
    }
}
