//
//  FileManager.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation

extension FileManager {
    internal func filteredMusicFileURLs(inDirectory directory: String) -> [URL] {
        guard let enumerator = enumerator(at: URL(fileURLWithPath: directory), includingPropertiesForKeys: nil, options: [], errorHandler: nil) else {
            return []
        }

        var musicFiles = [URL]()
        let enumeration: () -> Bool = {
            guard let fileURL = enumerator.nextObject() as? URL else {
                return false
            }
            if fileURL.isMusicFile {
                musicFiles.append(fileURL)
            }
            return true
        }
        while enumeration() {}
        return musicFiles
    }
}
