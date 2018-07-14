//
//  TrackItem.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 29.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

protocol TrackItemDelegate {
  func trackItemDoubleAction(_ trackItem: TrackItem)
}

class TrackItem: NSCollectionViewItem {
  
  var delegate: TrackItemDelegate?
  
  var track: Track? {
    didSet {
      updateTrackItem()
    }
  }
  
  var index: Int? {
    didSet {
      trackNumberLabel.stringValue = "\(index ?? 0) ."
    }
  }
  
  private func updateTrackItem() {
    guard let track = track else { return }
    if let artist = track.artist, let title = track.title {
      trackTitleLabel.stringValue = "\(artist) - \(title)"
    } else {
      trackTitleLabel.stringValue = "\(track.filename)"
    }
    durationLabel.stringValue = track.duration.durationText
  }
  
  private let stackView: NSStackView = {
    let stack = NSStackView()
    stack.orientation = .horizontal
    stack.alignment = .centerY
    stack.spacing = 4
    stack.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 4)
    stack.setClippingResistancePriority(.required, for: .horizontal)
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let trackArtistLabel: Label = {
    let label = Label()
    label.stringValue = " Artist"
    label.font = NSFont.systemFont(ofSize: 12)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.alignment = .left
    return label
  }()
  
  private let trackTitleLabel: Label = {
    let label = Label()
    label.stringValue = " Super Long and awesome Track Title"
    label.font = NSFont.systemFont(ofSize: 12)
    label.alignment = .left
    return label
  }()
  
  private let durationLabel: Label = {
    let label = Label()
    label.stringValue = "03:20"
    label.textColor = .secondaryLabelColor
    label.font = NSFont.monospacedDigitSystemFont(ofSize: 10, weight: NSFont.Weight.regular)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.alignment = .center
    return label
  }()
  
  private let trackNumberLabel: Label = {
    let label = Label()
    label.stringValue = ""
    label.font = NSFont.systemFont(ofSize: 8)
    label.textColor = .secondaryLabelColor
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.alignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    label.widthAnchor.constraint(equalToConstant: 24).isActive = true
    return label
  }()
  
  override var isSelected: Bool {
    didSet {
      changeView(forSelectedState: isSelected)
    }
  }
  
  override func loadView() {
    self.view = BackgroundView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    view.addSubview(stackView)
    stackView.fill(to: self.view)
    
    let leadingViews: [NSView] = [trackNumberLabel, trackTitleLabel]
    let centerViews: [NSView] = []
    let trailingViews: [NSView] = [durationLabel]
    
    leadingViews.forEach { stackView.addView($0, in: .leading) }
    centerViews.forEach { stackView.addView($0, in: .center) }
    trailingViews.forEach { stackView.addView($0, in: .trailing) }
  }
  
  private func changeView(forSelectedState isSelected: Bool) {
    guard let view = view as? BackgroundView else { return }
    if isSelected {
      if #available(OSX 10.14, *) {
        view.backgroundColor = NSColor.unemphasizedSelectedTextBackgroundColor
      } else {
        view.wantsLayer = true
        view.backgroundColor = NSColor.selectedTextBackgroundColor
        trackTitleLabel.textColor = .black
        [trackNumberLabel, durationLabel].forEach { $0.textColor = NSColor(white: 0.3, alpha: 1) }
      }
      view.layer?.cornerRadius = 4
    } else {
      view.backgroundColor = nil
      view.cornerRadius = nil
      view.layer = nil
      if #available(OSX 10.14, *) {} else {
        trackTitleLabel.textColor = .labelColor
        [trackNumberLabel, durationLabel].forEach { $0.textColor = .secondaryLabelColor }
        view.wantsLayer = false
      }
    }
  }
  
  override func mouseDown(with event: NSEvent) {
    if event.clickCount > 1 {
      delegate?.trackItemDoubleAction(self)
    } else {
      super.mouseDown(with: event)
    }
  }
}
