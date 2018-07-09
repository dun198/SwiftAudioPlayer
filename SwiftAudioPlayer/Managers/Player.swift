//
//  TrackPlaybackManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

extension Player {
  enum PlayerState {
    case idle
    case playing(Track)
    case paused(Track)
    
    var description: String {
      switch self {
      case .idle:
        return "idle"
      case .playing(let track):
        return "playing(\"\(track.filename)\")"
      case .paused(let track):
        return "paused(\"\(track.filename)\")"
      }
    }
    
    var currentTrack: Track? {
      switch self {
      case .paused(let track), .playing(let track):
        return track
      case .idle:
        return nil
      }
    }
  }
}

class Player: NSObject {
  static let shared = Player()
  
  private let notificationCenter: NotificationCenter!
  private let player = AVPlayer()
  
  // Bindable Variables
  private(set) var percentProgress: Dynamic<Double> = Dynamic(0)
  private(set) var playbackPosition: Dynamic<Double> = Dynamic(0)
  private(set) var playerState: PlayerState = .idle {
    didSet {
      print(playerState.description)
      switch playerState {
      case .idle:
        notificationCenter.post(name: .playbackStopped, object: nil)
      case .playing(let track):
        notificationCenter.post(name: .playbackStarted, object: track)
      case .paused(let track):
        notificationCenter.post(name: .playbackPaused, object: track)
      }
    }
  }
  
  init(notificationCenter: NotificationCenter = .default) {
    self.notificationCenter = notificationCenter
    super.init()
    setupObserver()
  }
  
  private func setupObserver() {
    // Add a periodic time observer to keep `percentProgress` and `playbackPosition` up to date.
    let interval = CMTimeMakeWithSeconds(0.5 , preferredTimescale: Int32(NSEC_PER_SEC))
    player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
        guard let duration = self?.currentTrack?.duration else { return }
      
        self?.playbackPosition.value = time.seconds
        self?.percentProgress.value = time.seconds / duration.seconds
      })
  }
  
  private func startPlayback(with track: Track) {
    if track != currentTrack {
      let item = AVPlayerItem(url: track.file)
      player.replaceCurrentItem(with: item)
    } else {
      switch playerState{
      case .playing:
        player.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
      case .idle, .paused:
        break
      }
    }
    player.play()
  }
  
  private func pausePlayback() {
    player.pause()
  }
  
  private func stopPlayback() {
    player.replaceCurrentItem(with: nil)
  }
  
  // MARK: - Public API
  
  var currentTrack: Track? {
    switch playerState {
    case .paused(let track), .playing(let track):
      return track
    case .idle:
      return nil
    }
  }
  
  var currentTime: CMTime? {
    return player.currentItem?.currentTime()
  }
  
  var isPlaying: Bool {
    switch playerState {
    case .playing(_):
      return true
    default:
      return false
    }
  }
  
  func play(_ track: Track) {
      startPlayback(with: track)
      playerState = .playing(track)
  }
  
  func resume() {
    guard let track = currentTrack else { return }
    play(track)
  }
  
  func pause() {
    switch playerState {
    case .idle, .paused:
      // Calling pause when we're not in a playing state
      // could be considered a programming error, but since
      // it doesn't do any harm, we simply break here.
      break
    case .playing(let track):
      playerState = .paused(track)
      pausePlayback()
    }
  }
  
  func togglePlayPause() {
    if isPlaying {
      pause()
    } else {
      resume()
    }
  }
  
  func stop() {
    playerState = .idle
    stopPlayback()
  }
  
  func setTrack(_ track: Track) {
    switch playerState {
    case .playing:
      play(track)
    case .idle, .paused:
      let item = AVPlayerItem(url: track.file)
      player.replaceCurrentItem(with: item)
      playerState = .paused(track)
    }
  }
  
  func seek(to seekValue: Double) {
    let time = CMTime(value: Int64(seekValue), timescale: 1)
    player.seek(to: time)
  }
}
