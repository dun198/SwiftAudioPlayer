//
//  Model.swift
//  NSTableViewGroupRows
//
//  Created by Tobias Dunkel on 17.11.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

/** this is the model which represents a track in the playlist
 */
struct Track: Equatable {

    static func == (lhs: Track, rhs: Track) -> Bool {
        // TODO: should be changed to URL later
        return lhs.filename == rhs.filename
    }

    let filename: String
    let duration: String

    // Optional Tags
    let title: String?
    let artist: String?
    let genre: String?
    let album: String?

    init(filename: String, duration: String, title: String? = nil, artist: String? = nil, album: String? = nil, genre: String? = nil) {
        self.filename = filename
        self.duration = duration
        self.title = title
        self.artist = artist
        self.album = album
        self.genre = genre
    }
}
