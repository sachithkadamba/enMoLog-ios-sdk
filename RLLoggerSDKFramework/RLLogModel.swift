//
//  RLogModel.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

class RLLogModel{
    
    var logText  = ""
    var logLevel = RLLogManager.logLevel.stringValue()
    var timeStamp = Date().stringValue()
    var keywords = ""
    
    init(messages:String...) {
       logText = messages.joined(separator: ": ")
    }
    
    init(messages:String..., keywords: String ) {
        logText = messages.joined(separator: ": ")
        self.keywords =  keywords
    }
    
    public func jsonString() ->String {
        
        let strJson = """
        {
            "logText": "\(logText)",
            "logLevel": "\(logLevel)",
            "timeStamp": "\(timeStamp)",
            "keyWords": "\(keywords)"
        }
        """
        
        return strJson
    }
    
    func logString() -> String {
        
        let strJson = """
        {
            "apiKey" : "\(RLLogManager.sharedInstance.apiKey)",
            "userType": "device",
            "deviceUUID" : "\(RLLogManager.sharedInstance.deviceUUID ?? "uuid not set")",
            "message" : \(jsonString())
        }
        """
        return strJson
        
    }
}
