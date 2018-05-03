//
//  Model.swift
//  NSTableViewGroupRows
//
//  Created by Tobias Dunkel on 17.11.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Foundation

/** this is the model which represents a track in the playlist
 */
struct Track: Equatable {

    static func == (lhs: Track, rhs: Track) -> Bool {
        // TODO: should be changed to URL later
        return lhs.file == rhs.file
    }

    let file: URL
    let filename: String
    
    let duration: String?
    
    // optional data
    let title: String?
    let artist: String?
    let genre: String?
    let album: String?

    init(_ file: URL) {
        self.file = file
        self.filename = file.deletingPathExtension().lastPathComponent
        
        let metadata = TrackMetadataHandler.getMetadata(for: file)
        self.title = metadata.title
        self.artist = metadata.artist
        self.duration = metadata.duration
        self.genre = metadata.genre
        self.album = metadata.album
    }
}
