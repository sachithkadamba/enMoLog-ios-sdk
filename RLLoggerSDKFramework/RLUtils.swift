//
//  Utils.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
}
