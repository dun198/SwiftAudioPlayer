//
//  CustomFlowLayout.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class CustomFlowLayout: NSCollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        super.shouldInvalidateLayout(forBoundsChange: newBounds)
        
        let widthInsets = sectionInset.left + sectionInset.right
        self.itemSize = NSSize(width: newBounds.width - widthInsets, height: itemSize.height)
        
        invalidateLayout()

        return true
    }
    
}
