//
//  AdaptiveToolbarSpaceItem.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class AdaptiveToolbarSpaceItem: NSToolbarItem {
    
    
    
    override init(itemIdentifier: NSToolbarItem.Identifier) {
        super.init(itemIdentifier: itemIdentifier)
        
        view?.setFrameSize(.init(width: 40, height: 20))
    }
}
