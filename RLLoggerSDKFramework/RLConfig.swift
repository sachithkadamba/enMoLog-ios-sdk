//
//  Config.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

struct Constants {
    var socketUrl = "ws://rlogger.enwidth.com:1337/"
    static let logQueueLimit = 20
    static let logFileSizeLimit = UInt64(1024*10)
}

