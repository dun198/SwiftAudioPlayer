//
//  VolumePopupView.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 09.07.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class VolumePopoverViewController: NSViewController {
  
  let player = Player.shared
  
  lazy var volumeSlider: NSSlider = {
    let slider = NSSlider()
    slider.isVertical = true
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.target = self
    slider.action = #selector(handleSliderAction)
    slider.floatValue = player.volume
    return slider
  }()
  
  override func loadView() {
    view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    view.addSubview(volumeSlider)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 32).isActive = true
    view.heightAnchor.constraint(equalToConstant: 96).isActive = true
    
    volumeSlider.fill(to: view, with: NSEdgeInsets(top: 8, left: 0, bottom: -8, right: 0))
  }
  
  @objc private func handleSliderAction() {
    player.volume = volumeSlider.floatValue
  }
}
