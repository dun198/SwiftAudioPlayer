//
//  TrackLoader.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let supportedAudioFormats: [String] = [
  "mp3",
  "wav",
  "aiff",
  "m4a"
]

class TrackLoader: NSObject {
  
  override init() {
    super.init()
  }
  
  /**
   Pop up an open panel.
   - Returns: Whether user dismissed the panel by clicking OK.
   */
  static func loadFilesOrDirectory(title: String, dir: URL? = nil, canChooseDir: Bool, ok: @escaping ([URL]) -> Void) {
    
    let panel = NSOpenPanel()
    panel.canCreateDirectories = false
    panel.canChooseFiles = true
    panel.resolvesAliases = true
    panel.allowsMultipleSelection = true
    panel.title = title
    panel.canChooseDirectories = canChooseDir
    // Only allow Audio Files and Folders
    panel.allowedFileTypes = [String(kUTTypeFolder), String(kUTTypeAudio)]
    panel.showsHiddenFiles = false
    
    if let dir = dir {
      panel.directoryURL = dir
    }
    
    // separate modal panel
    let result = panel.runModal()
    if result == .OK {
      let playableFiles = getPlayableFiles(in: panel.urls)
      ok(playableFiles)
    }
  }
  
  static func getPlayableFiles(in urls: [URL]) -> [URL] {
    var playableFiles: [URL] = []
    for url in urls {
      if url.hasDirectoryPath {
        // is directory
        guard let dirEnumerator = FileManager.default.enumerator(atPath: url.path) else { return [] }
        
        while let fileName = dirEnumerator.nextObject() as? String {
          guard !fileName.hasPrefix(".") else { continue }
          if supportedAudioFormats.contains(fileName.pathExtension.lowercased()) {
            playableFiles.append(url.appendingPathComponent(fileName))
          }
        }
      } else {
        // is file
        if supportedAudioFormats.contains(url.pathExtension.lowercased()) {
          playableFiles.append(url)
        }
      }
    }
    return playableFiles
  }
}
