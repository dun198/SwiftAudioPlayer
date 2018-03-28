//
//  MediumTitlebarViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 26.03.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MediumTitlebarViewController: NSTitlebarAccessoryViewController {

    @IBOutlet weak var firstStackView: NSStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
