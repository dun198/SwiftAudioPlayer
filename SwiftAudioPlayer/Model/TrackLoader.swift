//
//  TrackLoader.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 03.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

fileprivate let supportedAudioExt: [String] = [
    "mp3",
    "wav",
    "aiff"
]

class TrackLoader: NSObject {
    
    static let shared = TrackLoader()
    
    override init() {
        super.init()
    }
    
    /**
     Pop up an open panel.
     - Returns: Whether user dismissed the panel by clicking OK.
     */
    static func openFileOrFolder(title: String, dir: URL? = nil, canChooseDir: Bool, ok: @escaping ([URL]) -> Void) {
        let panel = NSOpenPanel()
        panel.title = title
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = canChooseDir
        panel.resolvesAliases = true
        panel.allowsMultipleSelection = true
        if let dir = dir {
            panel.directoryURL = dir
        }
        panel.begin() { result in
            if result == .OK {
                ok(panel.urls)
            }
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
                    if supportedAudioExt.contains(fileName.pathExtension.lowercased()) {
                        playableFiles.append(url.appendingPathComponent(fileName))
                    }
                }
            } else {
                // is file
                if supportedAudioExt.contains(url.pathExtension.lowercased()) {
                    playableFiles.append(url)
                }
            }
        }
        return playableFiles
    }
}
