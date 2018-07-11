//
//  NowPlayingInfoCenter+Track.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 11.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import MediaPlayer

extension MPNowPlayingInfoCenter {
  
  func updateNowPlayingInfo(for track: Track?, playbackRate: Float, playbackPosition: TimeInterval = 0) {
    guard let track = track else {
      print("clearNowPlayingInfo")
      playbackState = .stopped
      nowPlayingInfo = nil
      return
    }
    print("updateNowPlayingInfo(for: \"\(track.filename)\")")
    
    if playbackRate == 0 {
      playbackState = .paused
    } else {
      playbackState = .playing
    }
    
    var info = nowPlayingInfo ?? [String: Any]()
    
    let title = track.title ?? track.filename
    let duration = track.duration
    
    //    let artworkData = Data()
    //    let image = NSImage(data: artworkData) ?? NSImage()
    //    let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> NSImage in
    //      return image
    //    })
    
    info[MPMediaItemPropertyTitle] = title
    info[MPMediaItemPropertyPlaybackDuration] = duration
    info[MPNowPlayingInfoPropertyDefaultPlaybackRate] = playbackRate
    info[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPosition
    
    if let artist = track.artist {
      info[MPMediaItemPropertyArtist] = artist
    }
    if let album = track.album {
      info[MPMediaItemPropertyAlbumTitle] = album
    }
    
    if #available(OSX 10.13.2, *) {
      //      nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
    } else {
      // Fallback on earlier versions
    }
    
    nowPlayingInfo = info
  }
  
  func updateNowPlayingProgress(forPlaybackPosition playbackPosition: TimeInterval) {
    var info = nowPlayingInfo ?? [String: Any]()
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPosition
    nowPlayingInfo = info
  }
}
