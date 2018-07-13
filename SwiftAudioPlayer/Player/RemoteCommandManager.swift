//
//  RemoteCommandManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 08.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import MediaPlayer

protocol RemoteCommandDelegate {
  
  func remoteCommandManagerDidPressPlay() -> MPRemoteCommandHandlerStatus
  
  func remoteCommandManagerDidPressPause() -> MPRemoteCommandHandlerStatus
  
  func remoteCommandManagerDidPressStop() -> MPRemoteCommandHandlerStatus
  
  func remoteCommandManagerDidTogglePlayPause() -> MPRemoteCommandHandlerStatus
  
  func remoteCommandManagerDidPressNext() -> MPRemoteCommandHandlerStatus
  
  func remoteCommandManagerDidPressPrevious() -> MPRemoteCommandHandlerStatus
  
  func remoteCommandManager(_ remoteCommandManager: RemoteCommandManager, didChangePlaybackPosition seekTime: CMTime) -> MPRemoteCommandHandlerStatus
}

// MARK: -
/// Manages media keys and delegates their actions to the RemoteCommandDelegate
class RemoteCommandManager: NSObject {

  fileprivate let remoteCommandCenter: MPRemoteCommandCenter
  
  var delegate: RemoteCommandDelegate?
  
  init(_ remoteCommandCenter: MPRemoteCommandCenter = .shared()) {
    self.remoteCommandCenter = remoteCommandCenter
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
    return delegate?.remoteCommandManagerDidPressPause() ?? .commandFailed
  }
  
  @objc func handlePlayCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    return delegate?.remoteCommandManagerDidPressPlay() ?? .commandFailed
  }
  
  @objc func handleStopCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    return delegate?.remoteCommandManagerDidPressStop() ?? .commandFailed
  }
  
  @objc func handleTogglePlayPauseCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    return delegate?.remoteCommandManagerDidTogglePlayPause() ?? .commandFailed
  }

  @objc func handleChangePlaybackPositionCommandEvent(_ event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
    let seekTime = CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    return delegate?.remoteCommandManager(self, didChangePlaybackPosition: seekTime) ?? .commandFailed
  }
  
  // MARK: Track Changing Command Handlers
  @objc func handleNextTrackCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    return delegate?.remoteCommandManagerDidPressNext() ?? .commandFailed
  }
  
  @objc func handlePreviousTrackCommandEvent(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
    return delegate?.remoteCommandManagerDidPressPrevious() ?? .commandFailed
  }
}
