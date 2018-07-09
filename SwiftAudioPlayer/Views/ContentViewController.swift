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

fileprivate let REORDER_TRACKS_PASTEBOARD_TYPE = "com.dunkeeel.SwiftAudioPlayer.TrackItem"

// MARK: Constants
fileprivate let shouldLoadMusicDirectory = false

// MARK: UI Constants
fileprivate let toolbarHeight: CGFloat = 36

fileprivate let playerControlsPaddingSide: CGFloat = 12
fileprivate let playerControlsPaddingBottom: CGFloat = 12
fileprivate let playerControlsMaxWidth: CGFloat = 464

fileprivate let nowPlayingMaxWidth: CGFloat = 500
fileprivate let nowPlayingPaddingTop: CGFloat = toolbarHeight + 8
fileprivate let nowPlayingPaddingBottom: CGFloat = 8

fileprivate let flowLayoutBottomInset: CGFloat = 80 + 66
fileprivate let flowLayoutTopInset: CGFloat = toolbarHeight + 8

fileprivate let showHideInterfaceThreshold: CGFloat = 5
fileprivate let showHideInterfaceAnimationDuration: TimeInterval = 0.4

// MARK: CollectionViewItem Identifiers
extension NSUserInterfaceItemIdentifier {
  static let playlistHeaderItem = NSUserInterfaceItemIdentifier("PlaylistHeaderItem")
  static let playlistTrackItem = NSUserInterfaceItemIdentifier("PlaylistTrackItem")
}

// MARK: - ContentViewController
class ContentViewController: NSViewController {
  
  private let player = Player.shared
  private var tracks: [Track] = [Track]()
  private var itemsForDraggingSession: Set<IndexPath> = []
  
  lazy var fadingControls: [NSView] = {
    var views: [NSView] = [playerControlsView, nowPlayingInfoView]
    if let toolbar = NSApp.mainWindow?.toolbar {
      toolbar.visibleItems?.compactMap{$0.view}.forEach{views.append($0)}
    }
    return views
  }()
  
  lazy var flowLayout: SingleColumnFlowLayout = {
    let layout = SingleColumnFlowLayout()
    layout.itemSize.height = 21
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
    if #available(OSX 10.14, *) {
    } else {
      cv.backgroundColors = [.clear]
    }
    cv.isSelectable = true
    cv.allowsMultipleSelection = true
    cv.registerForDraggedTypes([NSPasteboard.PasteboardType(REORDER_TRACKS_PASTEBOARD_TYPE)])
    cv.setDraggingSourceOperationMask(.move, forLocal: true)
    
    // register collectionView items
    cv.register(ContentHeaderItem.self, forItemWithIdentifier: .playlistHeaderItem)
    cv.register(TrackItem.self, forItemWithIdentifier: .playlistTrackItem)
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
  
  lazy var playerControlsView: PlayerControlsView = {
    let view = PlayerControlsView()
    view.cornerRadius = 6
    view.translatesAutoresizingMaskIntoConstraints = false
    view.playbackControlsView.playbackControlsDelegate = self
    return view
  }()
  
  lazy var nowPlayingInfoView: NowPlayingInfoView = {
    let view = NowPlayingInfoView()
    view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let toolbarBackgroundView: ToolbarBackgroundView = {
    let view = ToolbarBackgroundView()
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
//    setupTrackingAreas()
    
    if shouldLoadMusicDirectory {
      loadFilesFromMusicDirectory()
    }
  }
  
  private func setupViews() {
    view.addSubview(scrollView)
    view.addSubview(playerControlsView)
    view.addSubview(nowPlayingInfoView)
//    view.addSubview(toolbarBackgroundView)
    
    scrollView.fill(to: self.view)
    
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
    
    nowPlayingInfoView.rightAnchor
      .constraint(equalTo: playerControlsView.rightAnchor)
      .isActive = true
    nowPlayingInfoView.leftAnchor
      .constraint(greaterThanOrEqualTo: view.leftAnchor, constant: playerControlsPaddingSide)
      .isActive = true
    nowPlayingInfoView.bottomAnchor
      .constraint(equalTo: playerControlsView.topAnchor, constant: -nowPlayingPaddingBottom)
      .isActive = true
    nowPlayingInfoView.topAnchor
      .constraint(greaterThanOrEqualTo: view.topAnchor, constant: nowPlayingPaddingTop)
      .isActive = true
    nowPlayingInfoView.widthAnchor
      .constraint(lessThanOrEqualToConstant: nowPlayingMaxWidth)
      .isActive = true
    
//    toolbarBackgroundView.leftAnchor
//      .constraint(equalTo: view.leftAnchor)
//      .isActive = true
//    toolbarBackgroundView.rightAnchor
//      .constraint(equalTo: view.rightAnchor)
//      .isActive = true
//    toolbarBackgroundView.topAnchor
//      .constraint(equalTo: view.topAnchor)
//      .isActive = true
//    toolbarBackgroundView.heightAnchor
//      .constraint(equalToConstant: toolbarHeight + 1)
//      .isActive = true
  }
  
  private func setupObserver() {
    // observe if video plays/pauses
    player.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
  }
  
//  private func setupTrackingAreas() {
//    // add tracking area
//    view.addTrackingArea(NSTrackingArea(rect: view.visibleRect, options: [.activeAlways, .mouseMoved, .mouseEnteredAndExited, .inVisibleRect], owner: self, userInfo: nil))
//  }
  
  func showControls() {
    setViewState(to: .visible, for: fadingControls)
  }
  
  func fadeControls() {
    setViewState(to: .hidden, for: fadingControls)
  }
  
  private func setViewState(to state: Visibility, for views: [NSView]) {
    let alphaValue: CGFloat = state == .visible ? 1 : 0.2
    NSAnimationContext.runAnimationGroup({ (context) in
      context.duration = showHideInterfaceAnimationDuration
      context.timingFunction = CAMediaTimingFunction(name: .easeOut)
      for view in views {
        view.animator().alphaValue = alphaValue
      }
    })
  }
  
  private func loadFilesFromMusicDirectory() {
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
    let cell = collectionView.makeItem(withIdentifier: .playlistTrackItem, for: indexPath) as! TrackItem
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
  
  func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
    guard let draggingTypes = draggingInfo.draggingPasteboard.types else {
      print("invalid drop")
      return []
    }

    if draggingTypes.contains(NSPasteboard.PasteboardType(REORDER_TRACKS_PASTEBOARD_TYPE)) {
      if proposedDropOperation.pointee == NSCollectionView.DropOperation.on {
        proposedDropOperation.pointee = NSCollectionView.DropOperation.before
      }
      return NSDragOperation.move
    }
    
    print("invalid drop")
    return []
  }
  
  func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
    print("drop indexPath: ", indexPath)

    collectionView.deselectAll(nil)
    var newSelectionIndexes = Set<IndexPath>()
    
    collectionView.animator().performBatchUpdates({
      for i in 0 ..< itemsForDraggingSession.count {
        let dragIndexPath = itemsForDraggingSession.removeFirst()

        let dragIndex = dragIndexPath.item
        let dropIndex = indexPath.item + i
        let dropOffset = dragIndex >= dropIndex ? 0 : -1
        
        let track = tracks[dragIndex]
        tracks.remove(at: dragIndex)
        tracks.insert(track, at: dropIndex + dropOffset)
        
        let dropIndexPath = IndexPath(item: dropIndex + dropOffset, section: 0)
        collectionView.animator().moveItem(at: dragIndexPath, to: dropIndexPath)
        newSelectionIndexes.insert(dropIndexPath)
      }
    }, completionHandler: { success in
      collectionView.reloadData()
      collectionView.selectItems(at: newSelectionIndexes, scrollPosition: NSCollectionView.ScrollPosition.centeredHorizontally)
    })
    
    return true
  }
  
  func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, index: Int, dropOperation: NSCollectionView.DropOperation) -> Bool {
    print("drop")
    for i in 0..<itemsForDraggingSession.count {
      print(i)
    }
    
    for draggedItemIndexPath in itemsForDraggingSession {
      print( draggedItemIndexPath)
      collectionView.animator().moveItem(at: draggedItemIndexPath, to: (index <= draggedItemIndexPath.item) ? IndexPath(item: index, section: 0) : (IndexPath(item: index - 1, section: 0)))
    }
    return true
  }
  
  func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
    print("write items to pasteboard")
    let pbItem = NSPasteboardItem()
    if let trackItem = tracks[indexPath.item] as Track? {
      pbItem.setString(trackItem.file.absoluteString, forType: NSPasteboard.PasteboardType(REORDER_TRACKS_PASTEBOARD_TYPE))
      return pbItem;
    }
    return nil
  }
  
  func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
    print("beginn dragging session with:")
    itemsForDraggingSession = indexPaths
    print(itemsForDraggingSession)
  }
  
  func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
    print("ended dragging session")
    itemsForDraggingSession = []
  }
  
  func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
    return true
  }
}

// MARK: - NSCollectionViewDelegateFlowLayout
extension ContentViewController: NSCollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    return flowLayout.itemSize
  }
}

// MARK: - ToolbarDelegate
extension ContentViewController {
  
  func toggleSidebar() {
    guard let splitVC = parent as? MainSplitViewController else { return }
    splitVC.toggleSidebar(nil)
  }
  
  func addTracks() {
    TrackLoader.loadFilesOrDirectory(title: "Open File or Folder", canChooseDir: true) { (playableFiles) in
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

// MARK: - PlaybackControlsDelegate
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
    guard let currentTrack = player.currentTrack else { return }
    guard let nextTrackIndex = tracks.firstIndex(of: currentTrack)?.advanced(by: 1) else { return }
    print(nextTrackIndex)
    guard nextTrackIndex < tracks.count else { return }
    let nextTrack = tracks[nextTrackIndex]
    player.play(nextTrack)
  }
  
  @IBAction func prev(sender: Any) {
    guard let currentTrack = player.currentTrack else { return }
    guard let prevTrackIndex = tracks.firstIndex(of: currentTrack)?.advanced(by: -1) else { return }
    print(prevTrackIndex)
    guard prevTrackIndex >= 0 else { return }
    let prevTrack = tracks[prevTrackIndex]
    player.play(prevTrack)
  }
}
