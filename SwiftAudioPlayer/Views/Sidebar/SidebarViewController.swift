//
//  SidebarViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 01.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class SidebarViewController: NSViewController {
  
  private lazy var titleLabel: Label = {
    let label = Label()
    label.stringValue = "Folders"
    label.font = NSFont.boldSystemFont(ofSize: 20)
    label.textColor = NSColor.labelColor
    return label
  }()
  
  private lazy var titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48)
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupObserver()
  }
  
  private func setupViews() {
    view.addSubview(titleLabel)
    
    titleTopConstraint.isActive = true
    titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
  }
  
  private func setupObserver() {
    NotificationCenter.default
      .addObserver(self, selector: #selector(handleWillEnterFullscreen),
                   name: Notification.Name("windowWillEnterFullscreenNotification"),
                   object: nil)
    
    NotificationCenter.default
      .addObserver(self, selector: #selector(handleDidEnterFullscreen),
                   name: Notification.Name("windowDidEnterFullscreenNotification"),
                   object: nil)
    
    NotificationCenter.default
      .addObserver(self, selector: #selector(handleWillExitFullscreen),
                   name: Notification.Name("windowWillExitFullscreenNotification"),
                   object: nil)
  }
  
  @objc private func handleDidEnterFullscreen() {

  }
  
  @objc private func handleWillEnterFullscreen() {
    titleTopConstraint.constant = 16
  }
  
  @objc private func handleWillExitFullscreen() {
    titleTopConstraint.constant = 48
  }
}
