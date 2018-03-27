//
//  PlayerControlsViewController.swift
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

class PlayerControlsViewController: NSTitlebarAccessoryViewController {

    var playState: PlayState = .paused
    
    @IBOutlet weak var btnPlayPause: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func btnPlayPauseAction(_ sender: NSButton) {
        
        switch playState {
            case .paused:
                playState = .playing
                btnPlayPause.title = ""
            case .playing:
                playState = .paused
                btnPlayPause.title = ""

        }
    }
    
}
