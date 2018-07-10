//
//  RemoteCommandManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 08.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import MediaPlayer

class RemoteCommandManager: NSObject {

  fileprivate let remoteCommandCenter = MPRemoteCommandCenter.shared()
  fileprivate let player = Player.shared
  
  override init() {
    super.init()
    setupCommands()
  }
  
  private func setupCommands() {
    remoteCommandCenter.playCommand.addTarget(self, action: #selector(RemoteCommandManager.handlePlayCommandEvent(_:)))
    remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(RemoteCommandManager.handlePauseCommandEvent(_:)))
    remoteCommandCenter.stopCommand.addTarget(self, action: #selector(RemoteCommandManager.handleStopCommandEvent(_:)))
    remoteCommandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(RemoteCommandManager.handleTogglePlayPauseCommandEvent(_:)))
    remoteCommandCenter.nextTrackCommand.addTarget(self, action: #selector(RemoteCommandManager.handleNextTrackCommandEvent(_:)))
    remoteCommandCenter.previousTrackCommand.addTarget(self, action: #selector(RemoteCommandManager.handlePreviousTrackCommandEvent(_:)))
    remoteCommandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(RemoteCommandManager.handleChangePlaybackPositionCommandEvent(_:)))
    
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
    player.seek(to: seekTime)
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
