//
//  TracksViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 28.04.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

extension NSUserInterfaceItemIdentifier {
    static let headerViewItem = NSUserInterfaceItemIdentifier("HeaderViewItem")
    static let trackViewItem = NSUserInterfaceItemIdentifier("TrackViewItem")
}

class ContentViewController: NSViewController {
    
    let tracks: [Track] = [
        Track(filename: "01 A New Sensation (feat. Chris #2)", duration: "3:45", title: "A New Sensation (feat. Chris #2)", artist: "The Prosecution", album: "Words with Destiny", genre: "ska punk"),
        Track(filename: "02 The Last Shot", duration: "4:12", title: "The Last Shot", artist: "The Prosecution", album: "Words with Destiny", genre: "ska punk"),
        Track(filename: "03 Words of Peace", duration: "2:59", title: "Words of Peace", artist: "The Prosecution", album: "Words with Destiny", genre: "ska punk")
    ]
    
    lazy var flowLayout: CustomFlowLayout = {
        let layout = CustomFlowLayout()
        layout.itemSize.height = 24
        layout.sectionInset = NSEdgeInsets(top: 0, left: 8, bottom: 72 + 16, right: 16)
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
        cv.register(HeaderViewItem.self, forItemWithIdentifier: .headerViewItem)
        cv.register(TrackViewItem.self, forItemWithIdentifier: .trackViewItem)
        return cv
    }()
    
    let scrollView: NSScrollView = {
        let sv = NSScrollView()
        sv.hasVerticalScroller = false
        sv.hasHorizontalScroller = false
        sv.hasVerticalRuler = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let toolbarView: ContentToolbarView = {
        let view = ContentToolbarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playerBox: PlayerHUDView = {
        let view = PlayerHUDView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(toolbarView)
        view.addSubview(playerBox)

        scrollView.documentView = collectionView

        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        toolbarView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //playerBox.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 0).isActive = true
        playerBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        playerBox.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 16).isActive = true
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
        return cell
    }
}

extension ContentViewController: NSCollectionViewDelegate {
}

extension ContentViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return flowLayout.itemSize
    }
}
