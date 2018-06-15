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
    label.textColor = NSColor.labelColor
    return label
  }()
  
  lazy var topConstraint = titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 48)
  
//  lazy var titleImage: NSImageView = {
//    let image = NSImage(named: NSImage.touchBarFolderTemplateName)
//    let view = NSImageView(image: image!)
//    view.imageScaling = NSImageScaling.scaleProportionallyDown
//    view.translatesAutoresizingMaskIntoConstraints = false
//    return view
//  }()
//
//  lazy var parentDirectoryButton: ImageButton = {
//    let image = NSImage(named: NSImage.touchBarFolderTemplateName)
//    let button = ImageButton(image: image!)
//    button.translatesAutoresizingMaskIntoConstraints = false
//    //button.isBordered = true
//    return button
//  }()
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupObserver()
  }
  
  private func setupObserver() {
    NotificationCenter.default
      .addObserver(self, selector: #selector(handleWillEnterFullscreen),
        name: Notification.Name("windowWillEnterFullscreenNotification"),
        object: nil)
    
    NotificationCenter.default
      .addObserver(self, selector: #selector(handleWillExitFullscreen),
                   name: Notification.Name("windowWillExitFullscreenNotification"),
                   object: nil)
  }
  
  @objc private func handleWillEnterFullscreen() {
    topConstraint.constant = 16
  }
  
  @objc private func handleWillExitFullscreen() {
    topConstraint.constant = 48
  }
  
  private func setupViews() {
    view.addSubview(titleLabel)
//    view.addSubview(titleImage)
    
    topConstraint.isActive = true
    titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    
//    titleImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
//    titleImage.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
//    titleImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
    
//    parentDirectoryButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
//    parentDirectoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
  }
}
