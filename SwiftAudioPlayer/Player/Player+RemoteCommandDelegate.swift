//
//  Player+RemoteCommandDelegate.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 11.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import MediaPlayer

extension Player: RemoteCommandDelegate {
  
  func remoteCommandManagerDidPressPlay() -> MPRemoteCommandHandlerStatus {
    guard let track = currentTrack else { return .noSuchContent }
    play(track)
    return .success
  }
  
  func remoteCommandManagerDidPressPause() -> MPRemoteCommandHandlerStatus {
    pause()
    return .success
  }
  
  func remoteCommandManagerDidPressStop() -> MPRemoteCommandHandlerStatus {
    stop()
    return .success
  }
  
  func remoteCommandManagerDidTogglePlayPause() -> MPRemoteCommandHandlerStatus {
    togglePlayPause()
    return .success
  }
  
  func remoteCommandManagerDidPressNext() -> MPRemoteCommandHandlerStatus {
    next()
    return .success
  }
  
  func remoteCommandManagerDidPressPrevious() -> MPRemoteCommandHandlerStatus {
    previous()
    return .success
  }
  
  func remoteCommandManager(_ remoteCommandManager: RemoteCommandManager, didChangePlaybackPosition seekTime: CMTime) -> MPRemoteCommandHandlerStatus {
    seek(to: seekTime)
    return .success
  }
  
}
