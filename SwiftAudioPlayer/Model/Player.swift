//
//  Player.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation
import AVFoundation

private extension Player {
    enum PlayerState {
        case playing(AVPlayerItem)
        case paused(AVPlayerItem)
        case idle
    }
}


class Player: NSObject {
    static let shared = Player()
    
    private let player = AVPlayer()
    private var playerState = PlayerState.idle {
        didSet{ stateDidChange() }
    }
    
    private func stateDidChange() {
        print("state did change")
    }
    
    private func startPlayback(with item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)
        player.play()
    }
    
    private func pausePlayback() {
        player.pause()
    }
    
    // MARK: - Public API
    
    private var currentTrack = Track(filename: "Test", duration: "300")
    
    func play(_ item: AVPlayerItem) {
        playerState = .playing(item)
        startPlayback(with: item)
    }
    
    func pause() {
        switch playerState {
        case .idle, .paused:
            // Calling pause when we're not in a playing state
            // could be considered a programming error, but since
            // it doesn't do any harm, we simply break here.
            break
        case .playing(let item):
            playerState = .paused(item)
            pausePlayback()
        }
    }
    
    func some() {
        
    }
    
}
