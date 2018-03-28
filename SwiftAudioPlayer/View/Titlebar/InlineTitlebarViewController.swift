//
//  InlineTitlebarViewController.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 27.03.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import Cocoa

class InlineTitlebarViewController: NSTitlebarAccessoryViewController {

    var viewModel: ViewModelProtocol? {
        didSet {
            print("appState changed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        viewModel = ViewModel()

    }

    @IBAction func changeAppearanceAction(_ sender: Any) {
        guard let colorScheme = viewModel?.colorScheme.value else { return }

        switch colorScheme {
        case .dark:
            viewModel?.changeColorScheme(to: .light)

        case .light:
            viewModel?.changeColorScheme(to: .dark)

        }
    }
}
