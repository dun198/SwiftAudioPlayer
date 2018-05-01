//
//  ImageButton.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ImageButton: NSButton {
    
    convenience init(image: NSImage, width: CGFloat? = nil, height: CGFloat? = nil, scaling: NSImageScaling? = nil) {
        self.init(image: image, target: nil, action: nil)
                
        self.isBordered = false
        self.title = ""
        self.imagePosition = .imageOnly
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        if let scaling = scaling {
            self.imageScaling = scaling
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
