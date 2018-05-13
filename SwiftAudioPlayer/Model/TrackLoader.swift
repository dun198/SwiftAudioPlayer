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
  static func openFileOrFolder(title: String, dir: URL? = nil, canChooseDir: Bool, ok: @escaping ([URL]) -> Void) {
    
    let panel = NSOpenPanel()
    panel.canCreateDirectories = false
    panel.canChooseFiles = true
    panel.resolvesAliases = true
    panel.allowsMultipleSelection = true
    panel.title = title
    panel.canChooseDirectories = canChooseDir
    
    if let dir = dir {
      panel.directoryURL = dir
    }
    
    // separate modal panel
    let result = panel.runModal()
    if result == .OK {
      ok(panel.urls)
    }
    
    // modal sheet
//    guard let window = NSApplication.shared.mainWindow else { return }
//    panel.beginSheetModal(for: window) { result in
//      if result == .OK {
//        ok(panel.urls)
//      }
//    }
    
    // separate panel
//    panel.begin() { result in
//      if result == .OK {
//        ok(panel.urls)
//      }
//    }
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
