//
//  PlaybackControlsViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 26.03.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

enum PlayState {
    case paused
    case playing
}

class PlaybackControlsViewController: NSViewController {

    var playState: PlayState = .paused

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}

extension PlaybackControlsViewController: PlaybackControlsDelegate {
    
    @IBAction func playPause(sender: Any) {
        if let button = sender as? ImageButton {
            switch playState {
                
            case .paused:
                playState = .playing
                button.image = NSImage(named: NSImage.Name.touchBarPauseTemplate)
                
            case .playing:
                playState = .paused
                button.image = NSImage(named: NSImage.Name.touchBarPlayTemplate)
            }
        }
    }
    
    @IBAction func next(sender: Any) {
        print("pressed next")
    }
    
    @IBAction func prev(sender: Any) {
        print("pressed prev")
    }
    
}
