//
//  TrackMetadataHandler.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import AVFoundation

struct TrackMetadata {
  var title: String?
  var artist: String?
  var duration: Double!
  var genre: String?
  var album: String?
}

class TrackMetadataHandler {
  
  static func getBasicMetadata(for file: URL) -> TrackMetadata {
    
    let asset = AVURLAsset(url: file, options: nil)
    let commonMD = asset.commonMetadata
    var metadata = TrackMetadata()
    
    metadata.duration = asset.duration.seconds
    
    for item in commonMD {
      switch item.commonKey {
      case AVMetadataKey.commonKeyArtist:
        metadata.artist = item.stringValue!
      case AVMetadataKey.commonKeyTitle:
        metadata.title = item.stringValue!
      case AVMetadataKey.commonKeyAlbumName:
        metadata.album = item.stringValue!
      default:
        break
      }
    }
    
    return metadata
  }
  
}
