//
//  Toolbar.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class Toolbar: NSToolbar {
    
    let toggleSidebarItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleSidebar)
        return item
    }()
    
    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier)
        
        self.insertItem(withItemIdentifier: toggleSidebarItem.itemIdentifier, at: 0)
    }
    
}
