//
//  NowPlayingInfoManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 08.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import MediaPlayer

protocol NowPlayingInfoDataSource {
  func nowPlayingInfoCurrentTrack() -> Track?
  func nowPlayingInfoPlaybackPosition() -> TimeInterval
  func nowPlayingInfoPlaybackRate() -> Float
}

class NowPlayingInfoManager: NSObject {
  
  fileprivate let nowPlayingInfoCenter: MPNowPlayingInfoCenter
  fileprivate let notificationCenter: NotificationCenter
  
  var dataSource: NowPlayingInfoDataSource?

  init(_ nowPlayingInfoCenter: MPNowPlayingInfoCenter = .default(),
       notificationCenter: NotificationCenter = .default) {
    self.nowPlayingInfoCenter = nowPlayingInfoCenter
    self.notificationCenter = notificationCenter
    super.init()
    setupObserver()
  }
  
  private func setupObserver() {
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackStarted(_:)),
                                   name: .playbackStarted,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackStopped(_:)),
                                   name: .playbackStopped,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlaybackPaused(_:)),
                                   name: .playbackPaused,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlayerPositionChanged(_:)),
                                   name: .playerPositionChanged,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handleCurrentTrackChanged(_:)),
                                   name: .currentTrackChanged,
                                   object: nil)
  }
  
  @objc private func handlePlaybackStarted(_ notification: NSNotification) {
    nowPlayingInfoCenter.playbackState = .playing
    guard let dataSource = dataSource else { return }
    let elapsed = dataSource.nowPlayingInfoPlaybackPosition()
    nowPlayingInfoCenter.updateNowPlayingProgress(forPlaybackPosition: elapsed)
  }
  
  @objc private func handlePlaybackPaused(_ notification: NSNotification) {
    nowPlayingInfoCenter.playbackState = .paused
    guard let dataSource = dataSource else { return }
    let elapsed = dataSource.nowPlayingInfoPlaybackPosition()
    nowPlayingInfoCenter.updateNowPlayingProgress(forPlaybackPosition: elapsed)
  }
  
  @objc private func handlePlaybackStopped(_ notification: NSNotification) {
    nowPlayingInfoCenter.playbackState = .stopped
    nowPlayingInfoCenter.updateNowPlayingInfo(for: nil, playbackRate: 0)
  }
  
  @objc private func handleCurrentTrackChanged(_ notification: NSNotification) {
    guard let dataSource = dataSource else { return }
    let track = dataSource.nowPlayingInfoCurrentTrack()
    let playbackRate = dataSource.nowPlayingInfoPlaybackRate()
    DispatchQueue.main.async {
      self.nowPlayingInfoCenter.updateNowPlayingInfo(for: track, playbackRate: playbackRate)
    }
  }
  
  @objc private func handlePlayerPositionChanged(_ notification: NSNotification) {
    guard let dataSource = dataSource else { return }
    let elapsed = dataSource.nowPlayingInfoPlaybackPosition()
    nowPlayingInfoCenter.updateNowPlayingProgress(forPlaybackPosition: elapsed)
  }
}
