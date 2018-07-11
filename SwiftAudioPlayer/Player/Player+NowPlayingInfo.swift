//
//  Player+NowPlayingInfo.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 11.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import MediaPlayer

extension Player: NowPlayingInfoDataSource {
  
  func nowPlayingInfoCurrentTrack() -> Track? {
    return currentTrack
  }
  
  func nowPlayingInfoPlaybackPosition() -> TimeInterval {
    return playbackPosition.value.seconds
  }
  
  func nowPlayingInfoPlaybackRate() -> Float {
    return isPlaying ? 1 : 0
  }
  
}
  

