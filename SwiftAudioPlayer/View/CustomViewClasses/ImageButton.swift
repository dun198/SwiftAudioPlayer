//
//  ImageButton.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ImageButton: NSButton {
    
    convenience init(image: NSImage, size: NSSize = NSSize(width: 32, height: 32)) {
        self.init(image: image, target: nil, action: nil)
                
        self.isBordered = false
        self.title = ""
        self.imagePosition = .imageOnly
        
        self.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
//        self.setContentHuggingPriority(.required, for: .horizontal)
//        self.setContentHuggingPriority(.required, for: .vertical)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}
