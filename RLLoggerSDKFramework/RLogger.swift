//
//  RLogger.swift
//  ELogger
//
//  Created by sachith 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

//#if ISSWIFT
//    open class RLog  { }
//#else
    public class RLog: NSObject { }
//#endif

extension RLog {

    //#if ISSWIFT
    private static func log(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line, logLevel:RLLogLevel = .DEBUG) {
        
        RLLogManager.sharedInstance.serialQueue.async {
            
            if (logLevel.rawValue >= RLLogManager.logLevel.rawValue) {
                
                let fileName = NSURL(fileURLWithPath: filePath).lastPathComponent ?? ""
                
                let logObject = RLLogModel(messages: message,fileName, functionName, "line# " + String(lineNumber), keywords: keywords)
                RLLogManager.sharedInstance.logQueue.enqueue(logObject)
                RLNetworkManager.sharedInstance.sendLogs()
            }
        }
    #if DEBUG
    print("[\(filePath): \(lineNumber)] \(functionName) - \(message)")
    #endif
    
    }
    
    @objc public static func debug(_ message: String, keywords: String = "") {
        let logLevel:RLLogLevel = .DEBUG
        RLog.log(message, keywords: keywords, filePath: #file , functionName: #function, lineNumber: #line, logLevel: logLevel)
    }
    
//    public static func debug(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line) {
//        
//        let logLevel:RLLogLevel = .DEBUG
//        RLog.log(message, keywords: keywords, filePath: filePath, functionName: functionName, lineNumber: lineNumber, logLevel: logLevel)
//    }

    @objc public static func error(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line) {
        
        let logLevel:RLLogLevel = .ERROR
        RLog.log(message, keywords: keywords, filePath: filePath, functionName: functionName, lineNumber: lineNumber, logLevel: logLevel)
    }
    
    @objc public static func info(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line) {
        
        let logLevel:RLLogLevel = .INFO
        RLog.log(message, keywords: keywords, filePath: filePath, functionName: functionName, lineNumber: lineNumber, logLevel: logLevel)
    }
    
    @objc public static func warn(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line) {
        
        let logLevel:RLLogLevel = .WARN
        RLog.log(message, keywords: keywords, filePath: filePath, functionName: functionName, lineNumber: lineNumber, logLevel: logLevel)
    }
    
    @objc public static func fatal(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line) {
        
        let logLevel:RLLogLevel = .FATAL
        RLog.log(message, keywords: keywords, filePath: filePath, functionName: functionName, lineNumber: lineNumber, logLevel: logLevel)
    }
    
    @objc public static func off(_ message: String, keywords:String = "", filePath:String = #file, functionName:String = #function, lineNumber:Int = #line) {
        
        let logLevel:RLLogLevel = .OFF
        RLog.log(message, keywords: keywords, filePath: filePath, functionName: functionName, lineNumber: lineNumber, logLevel: logLevel)
    }
    
    //#else
    
//    private static func log(_ message: String, keywords:String = "", logLevel:RLLogLevel = .DEBUG) {
//
//        RLLogManager.sharedInstance.serialQueue.async {
//
//            if (logLevel.rawValue >= RLLogManager.logLevel.rawValue) {
//
//                let logObject = RLLogModel(messages: message, keywords: keywords)
//                RLLogManager.sharedInstance.logQueue.enqueue(logObject)
//                RLNetworkManager.sharedInstance.sendLogs()
//            }
//        }
//    }
//
//    public static func debug(_ message: String, keywords:String = "") {
//        let logLevel:RLLogLevel = .DEBUG
//        RLog.log(message, keywords: keywords, logLevel: logLevel)
//    }
//
//    public static func debug(_ message: String) {
//        let logLevel:RLLogLevel = .DEBUG
//        RLog.log(message, keywords: "", logLevel: logLevel)
//    }
//
//    public static func error(_ message: String, keywords:String = "") {
//        let logLevel:RLLogLevel = .ERROR
//        RLog.log(message, keywords: keywords, logLevel: logLevel)
//    }
//
//    public static func error(_ message: String) {
//        let logLevel:RLLogLevel = .ERROR
//        RLog.log(message, keywords: "", logLevel: logLevel)
//    }
//
//    public static func info(_ message: String, keywords:String = "") {
//        let logLevel:RLLogLevel = .INFO
//        RLog.log(message, keywords: keywords, logLevel: logLevel)
//    }
//
//    public static func info(_ message: String) {
//        let logLevel:RLLogLevel = .INFO
//        RLog.log(message, keywords: "", logLevel: logLevel)
//    }
//
//    public static func warn(_ message: String, keywords:String = "") {
//        let logLevel:RLLogLevel = .WARN
//        RLog.log(message, keywords: keywords, logLevel: logLevel)
//    }
//
//    public static func warn(_ message: String) {
//        let logLevel:RLLogLevel = .WARN
//        RLog.log(message, keywords: "", logLevel: logLevel)
//    }
//
//    public static func fatal(_ message: String, keywords:String = "") {
//        let logLevel:RLLogLevel = .FATAL
//        RLog.log(message, keywords: keywords, logLevel: logLevel)
//    }
//
//    public static func fatal(_ message: String) {
//        let logLevel:RLLogLevel = .FATAL
//        RLog.log(message, keywords: "", logLevel: logLevel)
//    }
//
//    public static func off(_ message: String, keywords:String = "") {
//        let logLevel:RLLogLevel = .OFF
//        RLog.log(message, keywords: keywords, logLevel: logLevel)
//    }
//
//    public static func off(_ message: String) {
//        let logLevel:RLLogLevel = .OFF
//        RLog.log(message, keywords: "", logLevel: logLevel)
//    }
    
 //   #endif
}
