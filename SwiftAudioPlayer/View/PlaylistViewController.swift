//
//  PlaylistViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 27.03.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

enum GroupType {
    case artist
    case genre
}

final class PlaylistViewController: NSViewController {

    var tracks: [Track] = []
    var trackDictionary: [String: [Track]] = [:]
    var groups: [String] = []

    @IBOutlet weak var outlineView: NSOutlineView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // create an array of tracks
        tracks = [Track(filename: "track1", duration: "3:45"),
                  Track(filename: "track2", duration: "2:32",
                        artist: "artist1", genre: "rock"),
                  Track(filename: "track3", duration: "4:20", genre: "pop")]
        for x in 1...1000 {
            let track = Track(filename: "track\(x+3)", duration: "3:45",
                              artist: "artist\(Int((x % 20) + 10))", genre: "electronic")
            tracks.append(track)
        }

        setupTableGroups(for: .artist)

        // set delegate and datasource of the outlineView
        outlineView.delegate = self
        outlineView.dataSource = self

    }

    private func groupTracks (_ tracks: [Track], by type: GroupType) -> [String: [Track]] {

        switch type {
        case .artist:
            return Dictionary(grouping: tracks) { $0.artist ?? "<unknown> Artist" }

        case .genre:
            return Dictionary(grouping: tracks) { $0.genre ?? "<unknown> Genre" }
        }
    }

    private func setupTableGroups(for type: GroupType) {
        // group tracks in a dictionary
        self.trackDictionary = groupTracks(tracks, by: type)

        // group headers as an array of strings
        self.groups = trackDictionary.flatMap { $0.0 }
        self.groups.sort()
    }

    @IBAction func groupByArtist(_ sender: Any) {
        setupTableGroups(for: .artist)
        outlineView.reloadData()
    }

    @IBAction func groupByGenre(_ sender: Any) {
        setupTableGroups(for: .genre)
        outlineView.reloadData()
    }

}

// MARK: - NSOutlineViewDataSource

extension PlaylistViewController: NSOutlineViewDataSource {

    // Returns the number of child items encompassed by a given item.
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard item != nil else { return groups.count }

        if let string = item as? String {
            if let items = trackDictionary[string] {
                return items.count
            }
        }

        return 0
    }

    // Returns the child item at the specified index of a given item.
    func outlineView(_ outlineView: NSOutlineView,
                     child index: Int, ofItem item: Any?) -> Any {
        guard item != nil else { return groups[index] }

        if let string = item as? String {
            if let group = trackDictionary[string] {
                return group[index]
            }
        }

        return 0
    }

    // Returns a Boolean value that indicates whether the a given item is expandable.
    // The item is located in the specified tableColumn of the view.
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is String
    }

    // Invoked by outlineView to return the data object associated with the specified item.
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?,
                     byItem item: Any?) -> Any? {

        if let title = item as? String {
            return title
        } else if let track = item as? [Track] {
            return track
        }
        return nil
    }

}

// MARK: - NSOutlineViewDelegate

extension PlaylistViewController: NSOutlineViewDelegate {

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is String
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        if let title = item as? String {
            guard let groupCell = outlineView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GroupCell"),
                owner: self) as? NSTableCellView else { return nil }
            groupCell.layer?.backgroundColor = CGColor.white
            let count = trackDictionary[title]!.count
            groupCell.textField!.stringValue = "\(title) (\(count))"
            // TODO: add summarized duration
            return groupCell

        } else if let track = item as? Track {
            guard let itemCell = outlineView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemCell"),
                owner: self) as? NSTableCellView else { return nil }
            itemCell.textField!.stringValue = track.filename
            // TODO: add duration field
            return itemCell
        }
        return nil
    }
}
