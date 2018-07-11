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
                                   selector: #selector(handlePlayerPositionChanged(_:)),
                                   name: .playerPositionChanged,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(handlePlayerStateChanged(_:)),
                                   name: .playerStateChanged,
                                   object: nil)
  }
  
  @objc private func handlePlayerStateChanged(_ notification: NSNotification) {
    updateNowPlayingInfo()
  }
  
  @objc private func handlePlayerPositionChanged(_ notification: NSNotification) {
    updateNowPlayingProgress()
  }
  
  private func updateNowPlayingInfo() {
    guard let dataSource = dataSource else { return }
    let track = dataSource.nowPlayingInfoCurrentTrack()
    let playbackRate = dataSource.nowPlayingInfoPlaybackRate()
    let elapsed = dataSource.nowPlayingInfoPlaybackPosition()
    nowPlayingInfoCenter.updateNowPlayingInfo(for: track, playbackRate: playbackRate, playbackPosition: elapsed)
  }
  
  private func updateNowPlayingProgress() {
    guard let dataSource = dataSource else { return }
    let elapsed = dataSource.nowPlayingInfoPlaybackPosition()
    nowPlayingInfoCenter.updateNowPlayingProgress(forPlaybackPosition: elapsed)
  }
  
}
