//
//  CollectionScrollView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 04.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol CollectionScrollViewDelegate {
  func collectionViewWillScroll(with event: NSEvent)
  func collectionViewDidScroll(with event: NSEvent)
}

class CollectionScrollView: NSScrollView {
  
  var delegate: CollectionScrollViewDelegate?
  
  override func scrollWheel(with event: NSEvent) {
    super.scrollWheel(with: event)
    
    if event.phase == NSEvent.Phase.began || event.phase == NSEvent.Phase.changed {
      delegate?.collectionViewWillScroll(with: event)
    } else if event.phase == NSEvent.Phase.ended || event.phase == NSEvent.Phase.cancelled {
      delegate?.collectionViewDidScroll(with: event)
    }
  }
}

