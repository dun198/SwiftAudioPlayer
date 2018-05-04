//
//  main.swift
//  SwiftAudioPlayer
//
//  Created by Tobias Dunkel on 04.05.18.
//  Copyright © 2018 Tobias Dunkel. All rights reserved.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate() //alloc main app's delegate class

app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
