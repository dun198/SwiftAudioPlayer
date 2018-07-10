//
//  NowPlayingInfoManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 08.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa
import MediaPlayer

class NowPlayingInfoManager: NSObject {
  
  fileprivate let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
  fileprivate let notificationCenter = NotificationCenter.default
  fileprivate let player = Player.shared
  
  fileprivate var displayingTrack: Track?
  
  override init() {
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
                                   selector: #selector(handlePlayerSeeked(_:)),
                                   name: .playerSeeked,
                                   object: nil)
  }
  
  @objc private func handlePlaybackStarted(_ notification: NSNotification) {
    updateNowPlayingInfoCenter(for: notification.object as? Track)
    nowPlayingInfoCenter.playbackState = .playing
  }
  
  @objc private func handlePlaybackStopped(_ notification: NSNotification) {
    updateNowPlayingInfoCenter(for: notification.object as? Track)
    nowPlayingInfoCenter.playbackState = .stopped
  }
  
  @objc private func handlePlaybackPaused(_ notification: NSNotification) {
    updateNowPlayingInfoCenter(for: notification.object as? Track)
    nowPlayingInfoCenter.playbackState = .paused
  }
  
  @objc private func handlePlayerSeeked(_ notification: NSNotification) {
    updateNowPlayingProgress(for: notification.object as? Double)
  }
  
  private func updateNowPlayingProgress(for playbackPosition: Double?) {
    guard let playbackPosition = playbackPosition else { return }
    var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPosition
    nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
  }
  
  private func updateNowPlayingInfoCenter(for track: Track?) {
    guard track != displayingTrack else { return }
    
    print("updateNowPlayingInfoCenter(for: \"\(track?.filename ?? "none")\")")
    guard let currentTrack = track else {
      nowPlayingInfoCenter.nowPlayingInfo = nil
      nowPlayingInfoCenter.playbackState = .stopped
      return
    }
    
    var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
    
    let title = currentTrack.filename
    let album = currentTrack.album ?? "Unknown"
    let duration = currentTrack.duration ?? 0
//    let artworkData = Data()
//    let image = NSImage(data: artworkData) ?? NSImage()
//    let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> NSImage in
//      return image
//    })
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = title
    nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
    
    if #available(OSX 10.13.2, *) {
//      nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
    } else {
      // Fallback on earlier versions
    }
    
    nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    displayingTrack = track
  }
}
