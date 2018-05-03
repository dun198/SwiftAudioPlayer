//
//  SpacerView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 02.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class SpacerView: NSView {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    convenience init(minSize: CGFloat? = nil, maxSize: CGFloat? = nil, orientation: Orientation = .horizontal) {
        self.init(frame: NSRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        switch orientation {
        case .horizontal:
            if let minSize = minSize {
                widthAnchor.constraint(greaterThanOrEqualToConstant: minSize).isActive = true
            }
            if let maxSize = maxSize {
                widthAnchor.constraint(lessThanOrEqualToConstant: maxSize).isActive = true
            }
            heightAnchor.constraint(equalToConstant: 1).isActive = true
            
        case .vertical:
            if let minSize = minSize {
                heightAnchor.constraint(greaterThanOrEqualToConstant: minSize).isActive = true
            }
            if let maxSize = maxSize {
                heightAnchor.constraint(lessThanOrEqualToConstant: maxSize).isActive = true
            }
            widthAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
}
