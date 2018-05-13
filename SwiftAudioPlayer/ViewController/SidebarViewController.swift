//
//  SidebarViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class SidebarViewController: NSViewController {
  
  lazy var titleLabel: Label = {
    let label = Label()
    label.stringValue = "Folders"
    label.font = NSFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  override func loadView() {
    self.view = NSVisualEffectView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = view as? NSVisualEffectView {
      view.blendingMode = .withinWindow
      view.state = .inactive
      view.material = .menu
    }
    setupViews()
  }
  
  private func setupViews() {
    view.addSubview(titleLabel)
    
    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
  }
  
}
