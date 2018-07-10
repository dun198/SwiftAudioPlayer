//
//  NSView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

extension NSView {
  
  func fill(to parent: NSView, with insets: NSEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
    self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom).isActive = true
    self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insets.left).isActive = true
    self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: insets.right).isActive = true
  }
  
  func center(inView view: NSView) {
    self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}
