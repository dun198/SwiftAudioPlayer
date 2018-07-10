//
//  RemoteCommandManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 08.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation
import MediaPlayer

class RemoteCommandManager: NSObject {

  fileprivate let remoteCommandCenter = MPRemoteCommandCenter.shared()
  fileprivate let player = Player.shared
  
  func activatePlaybackCommands(_ enable: Bool) {
    if enable {
      remoteCommandCenter.playCommand.addTarget(self, action: #selector(RemoteCommandManager.handlePlayCommandEvent(_:)))
      remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(RemoteCommandManager.handlePauseCommandEvent(_:)))
      remoteCommandCenter.stopCommand.addTarget(self, action: #selector(RemoteCommandManager.handleStopCommandEvent(_:)))
      remoteCommandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(RemoteCommandManager.handleTogglePlayPauseCommandEvent(_:)))
      
    }
    else {
      remoteCommandCenter.playCommand.removeTarget(self, action: #selector(RemoteCommandManager.handlePlayCommandEvent(_:)))
      remoteCommandCenter.pauseCommand.removeTarget(self, action: #selector(RemoteCommandManager.handlePauseCommandEvent(_:)))
      remoteCommandCenter.stopCommand.removeTarget(self, action: #selector(RemoteCommandManager.handleStopCommandEvent(_:)))
      remoteCommandCenter.togglePlayPauseCommand.removeTarget(self, action: #selector(RemoteCommandManager.handleTogglePlayPauseCommandEvent(_:)))
    }
    
    remoteCommandCenter.playCommand.isEnabled = enable
    remoteCommandCenter.pauseCommand.isEnabled = enable
    remoteCommandCenter.stopCommand.isEnabled = enable
    remoteCommandCenter.togglePlayPauseCommand.isEnabled = enable
  }
  
  func toggleNextTrackCommand(_ enable: Bool) {
    if enable {
      remoteCommandCenter.nextTrackCommand.addTarget(self, action: #selector(RemoteCommandManager.handleNextTrackCommandEvent(_:)))
    }
    else {
      remoteCommandCenter.nextTrackCommand.removeTarget(self, action: #selector(RemoteCommandManager.handleNextTrackCommandEvent(_:)))
    }
    
    remoteCommandCenter.nextTrackCommand.isEnabled = enable
  }
  
  func togglePreviousTrackCommand(_ enable: Bool) {
    if enable {
      remoteCommandCenter.previousTrackCommand.addTarget(self, action: #selector(RemoteCommandManager.handlePreviousTrackCommandEvent(_:)))
    }
    else {
      remoteCommandCenter.previousTrackCommand.removeTarget(self, action: #selector(RemoteCommandManager.handlePreviousTrackCommandEvent(_:)))
    }
    
    remoteCommandCenter.previousTrackCommand.isEnabled = enable
  }
  
  func toggleChangePlaybackPositionCommand(_ enable: Bool) {
    if enable {
        remoteCommandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(RemoteCommandManager.handleChangePlaybackPositionCommandEvent(_:)))
    }
    else {
        remoteCommandCenter.changePlaybackPositionCommand.removeTarget(self, action: #selector(RemoteCommandManager.handleChangePlaybackPositionCommandEvent(_:)))
    }

    remoteCommandCenter.changePlaybackPositionCommand.isEnabled = enable
  }

  // MARK: Playback Command Handlers
  @objc func handlePauseCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    player.pause()
    return .success
  }
  
  @objc func handlePlayCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    guard let track = player.currentTrack else { return .noSuchContent }
    player.play(track)
    return .success
  }
  
  @objc func handleStopCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    player.stop()
    return .success
  }
  
  @objc func handleTogglePlayPauseCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    player.togglePlayPause()
    return .success
  }

  @objc func handleChangePlaybackPositionCommandEvent(_ event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
    let seekTime = CMTimeMakeWithSeconds(event.positionTime, preferredTimescale: 1)
    player.seek(to: seekTime.seconds)
    return .success
  }
  
  // MARK: Track Changing Command Handlers
  @objc func handleNextTrackCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    if player.currentTrack != nil {
      player.next()
      return .success
    }
    else {
      return .noSuchContent
    }
  }
  
  @objc func handlePreviousTrackCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    if player.currentTrack != nil {
      player.previous()
      return .success
    }
    else {
      return .noSuchContent
    }
  }
}
