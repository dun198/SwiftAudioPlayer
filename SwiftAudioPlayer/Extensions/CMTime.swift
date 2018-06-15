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
    let totalSeconds = self.getSeconds()
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
