//
//  ViewController.swift
//  MyAudioPlayer
//
//  Created by Tobias Dunkel on 13.12.17.
//  Copyright © 2017 Tobias Dunkel. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }
    var uiState: UIState?

    override func viewDidLoad() {

        setupUI()
        super.viewDidLoad()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private func setupUI() {

        guard let viewModel = viewModel else { return }
        viewModel.uiState.bindAndFire { [unowned self] in
            self.uiState = $0
            self.someStuff()
        }

    }

    func someStuff() {
        print("someStuff")
    }

}
