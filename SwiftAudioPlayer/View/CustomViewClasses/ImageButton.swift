//
//  ImageButton.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ImageButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.isBordered = false
        self.title = ""
        self.imagePosition = .imageOnly
        self.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
