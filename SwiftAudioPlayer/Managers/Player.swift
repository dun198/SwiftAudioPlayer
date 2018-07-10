//
//  TrackPlaybackManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import AVFoundation
import MediaPlayer

private extension Player {
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
  }
}

class Player: NSObject {
  static let shared = Player()
  
  private let notificationCenter: NotificationCenter!
  private let player = AVPlayer()
  
  public var volume: Float! {
    didSet {
      player.volume = volume
      UserDefaults.standard.set(volume, forKey: Preferences.Key.volume.rawValue)
    }
  }
  
  private var isSeekInProgress = false
  private var chaseTime: CMTime = .zero
  
  // Bindable Dynamic Variables
  private(set) var percentProgress: Dynamic<Double> = Dynamic(0)
  private(set) var playbackPosition: Dynamic<CMTime> = Dynamic(.zero)
  
  private(set) var currentTrack: Track? = nil {
    didSet {
      notificationCenter.post(name: .currentTrackChanged, object: currentTrack)
    }
  }
  
  private var timeObserverToken: Any?
  
  private var playerState: PlayerState = .idle {
    didSet {
      notificationCenter.post(name: .playerStateChanged, object: nil)
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
    self.volume = UserDefaults.standard.float(forKey: Preferences.Key.volume.rawValue)
    super.init()
    setupObserver()
  }
  
  deinit {
    timeObserverToken = nil
    player.replaceCurrentItem(with: nil)
  }
  
  private func setupObserver() {
    // Add a periodic time observer to keep `percentProgress` and `playbackPosition` up to date.
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
      guard let duration = self?.currentTrack?.duration else { return }
        self?.playbackPosition.value = time
        self?.percentProgress.value = time.seconds / duration
      })
  }
  
  private func startPlayback(with track: Track) {
    if track != currentTrack {
      let item = AVPlayerItem(url: track.file)
      player.replaceCurrentItem(with: item)
      currentTrack = track
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
    currentTrack = nil
  }
  
  // MARK: - Public API
  
  var isPlaying: Bool {
    switch playerState {
    case .playing(_):
      return true
    default:
      return false
    }
  }
  
  var playbackRate: Float {
    return player.rate
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
  
  func next() {
    notificationCenter.post(name: .playNextTrack, object: nil)
  }
  
  func previous() {
    notificationCenter.post(name: .playPreviousTrack, object: nil)
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
  
  func seek(to seekTime: CMTime) {
    pausePlayerAndSeekSmoothlyToTime(newChaseTime: seekTime)
  }
  
  private func pausePlayerAndSeekSmoothlyToTime(newChaseTime:CMTime) {
    player.pause()
    if CMTimeCompare(newChaseTime, chaseTime) != 0
    {
      chaseTime = newChaseTime;
      if !isSeekInProgress
      {
        actuallySeekToTime()
      }
    } else {
      if isPlaying { player.play() }
    }
  }
  
  func actuallySeekToTime() {
    isSeekInProgress = true
    
    let seekTimeInProgress = chaseTime
    let tolerance: CMTime = .zero
    
    player.seek(to: seekTimeInProgress, toleranceBefore: tolerance,
                toleranceAfter: tolerance) { [unowned self] (isFinished) in
      if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
        self.isSeekInProgress = false
        self.notificationCenter.post(name: .playerSeeked, object: seekTimeInProgress)
        if self.isPlaying { self.player.play() }
      }
      else
      {
        self.actuallySeekToTime()
      }
    }
  }
}
