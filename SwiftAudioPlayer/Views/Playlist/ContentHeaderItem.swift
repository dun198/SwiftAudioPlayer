//
//  HeaderViewItem.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class ContentHeaderItem: NSCollectionViewItem {
  
  let titleLabel: Label = {
    let label = Label()
    label.stringValue = "Tracks"
    label.font = NSFont.systemFont(ofSize: 20)
    return label
  }()
  
  override func loadView() {
    self.view = NSView()
    view.wantsLayer = true
    view.layer?.cornerRadius = 6
    view.layer?.borderColor = NSColor.darkGray.cgColor
    view.layer?.borderWidth = 1
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {        
    view.addSubview(titleLabel)
    titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
  }    
}
