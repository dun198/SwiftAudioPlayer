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
  
  fileprivate let notificationCenter: NotificationCenter!
  fileprivate let nowPlayingInfoCenter: MPNowPlayingInfoCenter!
  
  fileprivate let player = AVPlayer()
  
  fileprivate var seekInProgress = false
  fileprivate var chaseTime: CMTime = .zero
  
  // Bindable Dynamic Variables
  private(set) var percentProgress: Dynamic<Double> = Dynamic(0)
  private(set) var playbackPosition: Dynamic<CMTime> = Dynamic(.zero)
  
  private var playerItem: AVPlayerItem! {
    willSet {
      if playerItem != nil {
        notificationCenter.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
      }
    }
    didSet {
      if playerItem != nil {
        notificationCenter.addObserver(self, selector: #selector(handleAVPlayerItemDidPlayToEndTimeNotification(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
      }
    }
  }
  
  private(set) var currentTrack: Track? = nil {
    didSet {
      updateTrackMetadata()
      notificationCenter.post(name: .currentTrackChanged, object: currentTrack)
    }
  }
  
  private var timeObserverToken: Any?
  
  private var playerState: PlayerState = .idle {
    didSet {
      updatePlaybackMetadata()
//      print("playerState changed to: \(playerState.description)")
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
  
  // MARK: Lifecycle
  init(notificationCenter: NotificationCenter = .default, nowPlayingInfoCenter: MPNowPlayingInfoCenter = .default()) {
    self.notificationCenter = notificationCenter
    self.nowPlayingInfoCenter = nowPlayingInfoCenter
    self.volume = UserDefaults.standard.float(forKey: Preferences.Key.volume.rawValue)
    super.init()
    setupObserver()
  }
  
  deinit {
    timeObserverToken = nil
    player.replaceCurrentItem(with: nil)
  }
  
  // MARK: Setup
  private func setupObserver() {
    // Add a periodic time observer to keep `percentProgress` and `playbackPosition` up to date.
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
      guard let duration = self?.currentTrack?.duration else { return }
        self?.playbackPosition.value = time
        self?.percentProgress.value = time.seconds / duration
      })
  }
  
  // MARK: Private Methods
  private func startPlayback(with track: Track) {
    if track != currentTrack {
      playerItem = AVPlayerItem(url: track.file)
      player.replaceCurrentItem(with: playerItem)
      currentTrack = track
    } else if isPlaying {
      player.pause()
      seek(to: .zero)
    }
    player.play()
    playerState = .playing(track)
  }
  
  private func pausePlayback(with track: Track) {
    player.pause()
    playerState = .paused(track)
  }
  
  private func stopPlayback() {
    player.replaceCurrentItem(with: nil)
    currentTrack = nil
    playerState = .idle
  }
  
  private func pausePlayerAndSeekSmoothlyToTime(newChaseTime:CMTime) {
    player.pause()
    if CMTimeCompare(newChaseTime, player.currentTime()) != 0
    {
      chaseTime = newChaseTime;
      if !seekInProgress
      {
        actuallySeekToTime()
      }
    } else {
      if isPlaying { player.play() }
    }
  }
  
  private func actuallySeekToTime() {
    seekInProgress = true
    
    let seekTimeInProgress = chaseTime
    let tolerance: CMTime = .zero
    
    player.seek(to: seekTimeInProgress, toleranceBefore: tolerance,
                toleranceAfter: tolerance) { [unowned self] (isFinished) in
                  if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                    self.seekInProgress = false
                    if self.isPlaying { self.player.play() }
                    self.updatePlaybackMetadata()
                    self.notificationCenter.post(name: .playerPositionChanged, object: seekTimeInProgress)
                  }
                  else
                  {
                    self.actuallySeekToTime()
                  }
    }
  }
  
  // MARK: Public API
  
  public var volume: Float! {
    didSet {
      player.volume = volume
      UserDefaults.standard.set(volume, forKey: Preferences.Key.volume.rawValue)
    }
  }
  
  public var playbackRate: Float {
    return player.rate
  }
  
  public var isPlaying: Bool {
    switch playerState {
    case .playing(_):
      return true
    default:
      return false
    }
  }
  
  public var isPaused: Bool {
    switch playerState {
    case .paused(_):
      return true
    default:
      return false
    }
  }
  
  public var isStopped: Bool {
    switch playerState {
    case .paused(_):
      return true
    default:
      return false
    }
  }
  
  public var isSeekInProgress: Bool {
    return seekInProgress
  }
  
  func play(_ track: Track) {
      startPlayback(with: track)
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
      pausePlayback(with: track)
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
  
  // MARK: Notification Handlers
  @objc private func handleAVPlayerItemDidPlayToEndTimeNotification(notification: NSNotification) {
    next()
  }
}

// MARK: - MPNowPlayingInforCenter Management
private extension Player {
  
  func updateTrackMetadata() {
    guard let track = currentTrack else {
      print("clearNowPlayingInfo")
      nowPlayingInfoCenter.nowPlayingInfo = nil
      nowPlayingInfoCenter.playbackState = .stopped
      return
    }
    
    print("updateTrackMetadata(for: \"\(track.filename)\")")
    
    var info = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
    
    //    let artworkData = Data()
    //    let image = NSImage(data: artworkData) ?? NSImage()
    //    let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> NSImage in
    //      return image
    //    })
    
    info[MPMediaItemPropertyTitle] = track.title ?? track.filename
    info[MPMediaItemPropertyPlaybackDuration] = track.duration
    info[MPMediaItemPropertyArtist] = track.artist ?? ""
    info[MPMediaItemPropertyAlbumTitle] = track.album ?? ""
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime().seconds
    
    //    if #available(OSX 10.13.2, *) {
    //      nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
    //    } else {
    //      // Fallback on earlier versions
    //    }
    
    DispatchQueue.main.async { [unowned self] in
      self.nowPlayingInfoCenter.nowPlayingInfo = info
    }
  }
  
  func updatePlaybackMetadata() {
    print("updatePlaybackMetadata")
    
    var info = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
    
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime().seconds
    info[MPNowPlayingInfoPropertyDefaultPlaybackRate] = playbackRate
    info[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    
    nowPlayingInfoCenter.nowPlayingInfo = info
    
    if playbackRate == 0.0 {
      nowPlayingInfoCenter.playbackState = .paused
    }
    else {
      nowPlayingInfoCenter.playbackState = .playing
    }
  }
  
}
