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
    return .init(rawValue: "Player.playbackStarted")
  }
  
  static var playbackPaused: Notification.Name {
    return .init(rawValue: "Player.playbackPaused")
  }
  
  static var playbackStopped: Notification.Name {
    return .init(rawValue: "Player.playbackStopped")
  }
}
