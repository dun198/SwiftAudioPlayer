//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa
import AVFoundation

fileprivate let toolbarHeight: CGFloat = 36
fileprivate let playerPanelPadding: CGFloat = 16

fileprivate let showHideInterfaceThreshold: CGFloat = 5

fileprivate var tracks: [Track] = [Track]()

extension NSUserInterfaceItemIdentifier {
    static let headerViewItem = NSUserInterfaceItemIdentifier("HeaderViewItem")
    static let trackViewItem = NSUserInterfaceItemIdentifier("TrackViewItem")
}

class ContentViewController: NSViewController {
    
    let player = Player()
    
    let backgroundEffectView: NSVisualEffectView = {
        let view = NSVisualEffectView()
        view.material = NSVisualEffectView.Material.appearanceBased
        view.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        view.state = NSVisualEffectView.State.inactive
        return view
    }()
    
    lazy var flowLayout: CustomFlowLayout = {
        let layout = CustomFlowLayout()
        layout.itemSize.height = 20
        layout.sectionInset = NSEdgeInsets(top: toolbarHeight, left: 8, bottom: 80 + 16, right: 8)
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
        cv.register(HeaderViewItem.self, forItemWithIdentifier: .headerViewItem)
        cv.register(TrackViewItem.self, forItemWithIdentifier: .trackViewItem)
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
    
    lazy var playerBox: PlayerControlsView = {
        let view = PlayerControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let topGradientView: NSView = {
//        let view = GradientView()
//        view.topGradientColor = NSColor.black
//        view.topColorLocation = 1.4
//        return view
//    }()
//
//    let bottomGradientView: GradientView = {
//        let view = GradientView()
//        view.bottomGradientColor = NSColor.black
//        view.bottomColorLocation = -0.4
//        return view
//    }()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadFilesForHomeDirectory()
        
//        setupObserver()
        
        // add tracking area
        view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.activeAlways, .inVisibleRect, .mouseMoved, .mouseEnteredAndExited], owner: self, userInfo: nil))
    }
    
//    private func setupObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(scrollViewDidScroll), name: NSScrollView.willStartLiveScrollNotification, object: self.scrollView)
//    }
    
//    @objc func scrollViewDidScroll() {
//        fadeControls()
//    }
    
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
    
    private func showControls() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.4
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            self.playerBox.animator().alphaValue = 1
            self.toolbarView.animator().alphaValue = 1
        })
    }
    
    private func fadeControls() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.4
            context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            self.playerBox.animator().alphaValue = 0.2
            self.toolbarView.animator().alphaValue = 0.2
        })
    }
    
    private func loadFilesForHomeDirectory() {
        let musicDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Music")
        let playableFiles = TrackLoader.getPlayableFiles(in: [musicDirectory])
        playableFiles.forEach { tracks.append(Track($0)) }
        self.collectionView.reloadData()
    }
    
    private func setupViews() {
        view.addSubview(backgroundEffectView)
        view.addSubview(scrollView)
        view.addSubview(playerBox)
        view.addSubview(toolbarView)
//        view.addSubview(topGradientView, positioned: NSWindow.OrderingMode.above, relativeTo: scrollView)
//        view.addSubview(bottomGradientView, positioned: NSWindow.OrderingMode.above, relativeTo: scrollView)

        backgroundEffectView.fill(to: self.view)
        scrollView.fill(to: self.view)
        
        toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        toolbarView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        
        playerBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -playerPanelPadding).isActive = true
        playerBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: playerPanelPadding).isActive = true
        playerBox.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 8 + toolbarHeight).isActive = true

//        topGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        topGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        topGradientView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        topGradientView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
//
//        bottomGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        bottomGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        bottomGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        bottomGradientView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
    }
}

extension ContentViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: .trackViewItem, for: indexPath) as! TrackViewItem
        cell.track = tracks[indexPath.item]
        cell.trackNumberLabel.stringValue = "\(indexPath.item) ."
        cell.delegate = self
        return cell
    }
}

extension ContentViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItem.HighlightState) {
        if highlightState == NSCollectionViewItem.HighlightState.forSelection {
//            print("selected cell ", indexPaths)
        }
    }
}

extension ContentViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return flowLayout.itemSize
    }
}

extension ContentViewController: ToolbarDelegate {
    func toggleSidebar() {
        guard let splitVC = parent as? MainSplitViewController else { return }
        splitVC.toggleSidebar(nil)
    }
    
    func addTracks() {
        TrackLoader.openFileOrFolder(title: "Open File or Folder", canChooseDir: true) { (selectedURLs) in
            let playableFiles = TrackLoader.getPlayableFiles(in: selectedURLs)
            playableFiles.forEach { tracks.append(Track($0)) }
            self.collectionView.reloadData()
        }
    }
    
    func removeAllTracks() {
        tracks.removeAll()
        self.collectionView.reloadData()
    }
}

extension ContentViewController: TrackItemDelegate {
    func trackItemDoubleAction(for track: Track?) {
        guard let track = track else { return }
        player.play(track)
    }
}

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
