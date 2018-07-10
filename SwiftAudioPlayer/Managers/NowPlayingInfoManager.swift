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
    notificationCenter.addObserver(self,
                                   selector: #selector(handleCurrentTrackChanged(_:)),
                                   name: .currentTrackChanged,
                                   object: nil)
  }
  
  @objc private func handlePlaybackStarted(_ notification: NSNotification) {
    updateNowPlayingProgress(for: player.playbackPosition.value)
    nowPlayingInfoCenter.playbackState = .playing
  }
  
  @objc private func handlePlaybackPaused(_ notification: NSNotification) {
    nowPlayingInfoCenter.playbackState = .paused
    updateNowPlayingProgress(for: player.playbackPosition.value)
  }
  
  @objc private func handlePlaybackStopped(_ notification: NSNotification) {
    updateNowPlayingInfo(for: nil)
  }
  
  @objc private func handleCurrentTrackChanged(_ notification: NSNotification) {
    let track = notification.object as? Track
    updateNowPlayingInfo(for: track)
    updateNowPlayingProgress(for: .zero)
  }
  
  @objc private func handlePlayerSeeked(_ notification: NSNotification) {
    updateNowPlayingProgress(for: notification.object as? CMTime)
  }
  
  private func updateNowPlayingProgress(for time: CMTime?) {
    guard let playbackPosition = time?.seconds else { return }
    var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPosition
    nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
  }
  
  private func updateNowPlayingInfo(for track: Track?) {
    guard track != displayingTrack else { return }
    
    print("updateNowPlayingInfo(for: \"\(track?.filename ?? "none")\")")
    guard let track = track else {
      nowPlayingInfoCenter.nowPlayingInfo = nil
      return
    }
    
    var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
    
    let title = track.title ?? track.filename
    let artist = track.artist ?? ""
    let album = track.album ?? "Unknown"
    let duration = track.duration ?? 0
//    let artworkData = Data()
//    let image = NSImage(data: artworkData) ?? NSImage()
//    let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> NSImage in
//      return image
//    })
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = title
    nowPlayingInfo[MPMediaItemPropertyArtist] = artist
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
