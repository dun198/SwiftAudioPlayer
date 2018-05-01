//
//  URL.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Foundation

extension URL {
    private enum MusicFileExtension: String {
        case mp3
    }
    
    internal var isMusicFile: Bool {
        return MusicFileExtension(rawValue: pathExtension) != nil
    }
}
