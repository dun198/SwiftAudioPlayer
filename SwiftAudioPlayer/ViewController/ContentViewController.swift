//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

// MARK: Constants
fileprivate let shouldLoadMusicDirectory = true

// MARK: UI Constants
fileprivate let toolbarHeight: CGFloat = 36

fileprivate let playerControlsPaddingSide: CGFloat = 8
fileprivate let playerControlsPaddingBottom: CGFloat = 8
fileprivate let playerControlsMaxWidth: CGFloat = 464

fileprivate let nowPlayingMaxWidth: CGFloat = 500
fileprivate let nowPlayingPaddingTop: CGFloat = toolbarHeight + 8
fileprivate let nowPlayingPaddingBottom: CGFloat = 8

fileprivate let flowLayoutBottomInset: CGFloat = 80 + 54
fileprivate let flowLayoutTopInset: CGFloat = toolbarHeight

fileprivate let showHideInterfaceThreshold: CGFloat = 5
fileprivate let showHideInterfaceAnimationDuration: TimeInterval = 0.4

// MARK: CollectionViewItem Identifiers
extension NSUserInterfaceItemIdentifier {
  static let headerViewItem = NSUserInterfaceItemIdentifier("HeaderViewItem")
  static let trackViewItem = NSUserInterfaceItemIdentifier("TrackViewItem")
}

// MARK: - ContentViewController
class ContentViewController: NSViewController {
  
  private let player = Player.shared
  private var tracks: [Track] = [Track]()
  
  lazy var flowLayout: SingleColumnFlowLayout = {
    let layout = SingleColumnFlowLayout()
    layout.itemSize.height = 20
    layout.sectionInset = NSEdgeInsets(top: flowLayoutTopInset, left: 8, bottom: flowLayoutBottomInset, right: 8)
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8
    return layout
  }()
  
  lazy var collectionView: NSCollectionView = {
    let cv = NSCollectionView()
    cv.dataSource = self
    cv.delegate = self
    cv.collectionViewLayout = flowLayout
    cv.backgroundColors = [.clear]
    cv.isSelectable = true
    // register collectionView items
    cv.register(ContentHeaderItem.self, forItemWithIdentifier: .headerViewItem)
    cv.register(TrackItem.self, forItemWithIdentifier: .trackViewItem)
    return cv
  }()
  
  lazy var scrollView: CollectionScrollView = {
    let sv = CollectionScrollView()
    sv.documentView = collectionView
    sv.translatesAutoresizingMaskIntoConstraints = false
    // hide vertical scroller
    sv.hasVerticalScroller = true
    sv.verticalScroller?.alphaValue = 0
    sv.delegate = self
    return sv
  }()
  
  lazy var toolbarView: ToolbarView = {
    let view = ToolbarView()
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var playerControlsView: PlayerControlsView = {
    let view = PlayerControlsView()
    view.cornerRadius = 6
    view.translatesAutoresizingMaskIntoConstraints = false
    view.playbackControlsView.playbackControlsDelegate = self
    return view
  }()
  
  lazy var nowPlayingView: NowPlayingInfoView = {
    let view = NowPlayingInfoView()
    view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func loadView() {
    view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupObserver()
    setupTrackingAreas()
    
    if shouldLoadMusicDirectory {
      loadFilesForHomeDirectory()
    }
  }
  
  private func setupViews() {
    view.addSubview(scrollView)
    view.addSubview(toolbarView)
    view.addSubview(playerControlsView)
    view.addSubview(nowPlayingView)
    
    scrollView.fill(to: self.view)
    
    toolbarView.leadingAnchor
      .constraint(equalTo: view.leadingAnchor)
      .isActive = true
    toolbarView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor)
      .isActive = true
    toolbarView.topAnchor
      .constraint(equalTo: view.topAnchor)
      .isActive = true
    toolbarView.heightAnchor
      .constraint(equalToConstant: toolbarHeight)
      .isActive = true
    
    playerControlsView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor, constant: -playerControlsPaddingBottom)
      .isActive = true
    playerControlsView.rightAnchor
      .constraint(equalTo: view.rightAnchor, constant: -playerControlsPaddingSide)
      .isActive = true
    playerControlsView.leftAnchor
      .constraint(greaterThanOrEqualTo: view.leftAnchor, constant: playerControlsPaddingSide)
      .isActive = true
    let playerControlsWidthConstraint = playerControlsView.widthAnchor
      .constraint(equalToConstant: playerControlsMaxWidth)
    playerControlsWidthConstraint.priority = NSLayoutConstraint.Priority.defaultLow
    playerControlsWidthConstraint.isActive = true
    
    nowPlayingView.rightAnchor
      .constraint(equalTo: playerControlsView.rightAnchor)
      .isActive = true
    nowPlayingView.leftAnchor
      .constraint(greaterThanOrEqualTo: view.leftAnchor, constant: playerControlsPaddingSide)
      .isActive = true
    nowPlayingView.bottomAnchor
      .constraint(equalTo: playerControlsView.topAnchor, constant: -nowPlayingPaddingBottom)
      .isActive = true
    nowPlayingView.topAnchor
      .constraint(greaterThanOrEqualTo: view.topAnchor, constant: nowPlayingPaddingTop)
      .isActive = true
    nowPlayingView.widthAnchor
      .constraint(lessThanOrEqualToConstant: nowPlayingMaxWidth)
      .isActive = true
  }
  
  private func setupObserver() {
    // observe if video plays/pauses
    player.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
  }
  
  private func setupTrackingAreas() {
    // add tracking area
    view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.activeAlways, .inVisibleRect, .mouseMoved, .mouseEnteredAndExited], owner: self, userInfo: nil))
  }
  
  private func showControls() {
    let controls = [toolbarView, playerControlsView, nowPlayingView]
    setViewState(to: .visible, for: controls)
  }
  
  private func fadeControls() {
    let controls = [toolbarView, playerControlsView, nowPlayingView]
    setViewState(to: .hidden, for: controls)
  }
  
  private func setViewState(to state: Visibility, for views: [NSView]) {
    let alphaValue: CGFloat = state == .visible ? 1 : 0.2
    NSAnimationContext.runAnimationGroup({ (context) in
      context.duration = showHideInterfaceAnimationDuration
      context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
      for view in views {
        view.animator().alphaValue = alphaValue
      }
    })
  }
  
  private func loadFilesForHomeDirectory() {
    let musicDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Music")
    let playableFiles = TrackLoader.getPlayableFiles(in: [musicDirectory])
    playableFiles.forEach { tracks.append(Track($0)) }
    self.collectionView.reloadData()
  }
  
  private func setWindowButtonsState(to state: Visibility) {
    guard let window = self.view.window else { return }
    let windowButtons: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
    let alphaValue: CGFloat = state == .visible ? 1 : 0
    windowButtons.forEach{ window.standardWindowButton($0)?.animator().alphaValue = alphaValue}
  }
  
  override func mouseMoved(with event: NSEvent) {
    super.mouseMoved(with: event)
    let yVelocity = abs(event.deltaY)
    let xVelocity = abs(event.deltaX)
    if yVelocity >= showHideInterfaceThreshold || xVelocity >= showHideInterfaceThreshold * 2{
      showControls()
    }
  }
  
  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
    fadeControls()
  }
  
  override func mouseEntered(with event: NSEvent) {
    super.mouseEntered(with: event)
    showControls()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "currentItem" {
      guard let duration = player.currentTrack?.duration else { return }
      playerControlsView.progressView.durationLabel.stringValue = duration.durationText
    }
  }
}

// MARK: - NSCollectionViewDataSource
extension ContentViewController: NSCollectionViewDataSource {
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return tracks.count
  }
  
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(withIdentifier: .trackViewItem, for: indexPath) as! TrackItem
    cell.track = tracks[indexPath.item]
    cell.trackNumberLabel.stringValue = "\(indexPath.item) ."
    cell.delegate = self
    return cell
  }
}

// MARK: - NSCollectionViewDelegate
extension ContentViewController: NSCollectionViewDelegate {
  
  func collectionView(_ collectionView: NSCollectionView, didChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItem.HighlightState) {
    if highlightState == NSCollectionViewItem.HighlightState.forSelection {
      //            print("selected cell ", indexPaths)
    }
  }
}

// MARK: - NSCollectionViewDelegateFlowLayout
extension ContentViewController: NSCollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    return flowLayout.itemSize
  }
}

// MARK: - ToolbarDelegate
extension ContentViewController: ToolbarDelegate {
  
  func toggleSidebar() {
    guard let splitVC = parent as? MainSplitViewController else { return }
    splitVC.toggleSidebar(nil)
  }
  
  func addTracks() {
    TrackLoader.openFileOrFolder(title: "Open File or Folder", canChooseDir: true) { (selectedURLs) in
      let playableFiles = TrackLoader.getPlayableFiles(in: selectedURLs)
      playableFiles.forEach { self.tracks.append(Track($0)) }
      self.collectionView.reloadData()
    }
  }
  
  func removeAllTracks() {
    tracks.removeAll()
    self.collectionView.reloadData()
  }
}

// MARK: - TrackItemDelegate
extension ContentViewController: TrackItemDelegate {
  
  func trackItemDoubleAction(_ trackItem: TrackItem) {
    guard let track = trackItem.track else { return }
    player.play(track)
    updateNowPlayingInfo(for: track)
  }
  
  private func updateNowPlayingInfo(for track: Track) {
    nowPlayingView.track = track
//    nowPlayingView.title = track.title
//    nowPlayingView.artist = track.artist
    guard let duration = track.duration else { return }
    let durationLabel = playerControlsView.progressView.durationLabel
    durationLabel.stringValue = duration.durationText
  }
}

// MARK: - CollectionScrollViewDelegate
extension ContentViewController: CollectionScrollViewDelegate {
  
  func collectionViewWillScroll(with event: NSEvent) {
    let yVelocity = abs(event.scrollingDeltaY)
    if yVelocity >= showHideInterfaceThreshold {
      fadeControls()
    }
  }
  
  func collectionViewDidScroll(with event: NSEvent) {
  }
}

// MARK: - PlayerControlsDelegate
extension ContentViewController: PlaybackControlsDelegate {
  
  @IBAction func playPause(sender: Any) {
    if player.isPlaying {
      player.pause()
    } else {
      guard let track = player.currentTrack else { return }
      player.play(track)
    }
  }
  
  @IBAction func next(sender: Any) {
    print("pressed next")
  }
  
  @IBAction func prev(sender: Any) {
    print("pressed prev")
  }
}
