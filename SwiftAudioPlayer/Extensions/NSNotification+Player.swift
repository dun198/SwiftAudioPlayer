//
//  NSNotification.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 06.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation

extension Notification.Name {
  static var playbackStarted: Notification.Name {
    return .init("playbackStartedNotification")
  }
  
  static var playbackPaused: Notification.Name {
    return .init("playbackPausedNotification")
  }
  
  static var playbackStopped: Notification.Name {
    return .init("playbackStoppedNotification")
  }
  
  static var currentTrackChanged: Notification.Name {
    return .init("currentTrackChangedNotification")
  }
  
  static var playerStateChanged: Notification.Name {
    return .init("playerStateChangedNotification")
  }
  
  static var playerSeeked: Notification.Name {
    return .init("playerSeeked")
  }
  
  static var playNextTrack: Notification.Name {
    return .init("playNextTrackNotification")
  }
  
  static var playPreviousTrack: Notification.Name {
    return .init("playPreviousTrackNotification")
  }
}
