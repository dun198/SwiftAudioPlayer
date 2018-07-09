//
//  CMTime.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import AVFoundation

extension CMTime {
  var durationText:String {
    let totalSeconds = self.seconds
    let hours:Int = Int(totalSeconds / 3600)
    let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
    let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
    
    if hours > 0 {
      return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    } else {
      return String(format: "%02i:%02i", minutes, seconds)
    }
  }
}

extension Double {
  var durationText: String {
    let hours:Int = Int(self / 3600)
    let minutes:Int = Int(self.truncatingRemainder(dividingBy: 3600) / 60)
    let seconds:Int = Int(self.truncatingRemainder(dividingBy: 60))
    
    if hours > 0 {
      return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    } else {
      return String(format: "%02i:%02i", minutes, seconds)
    }
  }
}
