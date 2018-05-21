//
//  RLogManager.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

@objc public enum RLLogLevel: Int {
   case ALL = 1, DEBUG, INFO, WARN, ERROR, FATAL, OFF
}

extension RLLogLevel {
    init(level:String) {
        
        switch level {
        case "ALL" : self = .ALL
        case "DEBUG" : self = .DEBUG
        case "INFO" : self = .INFO
        case "WARN" : self = .WARN
        case "ERROR" : self = .ERROR
        case "FATAL" : self = .FATAL
        case "OFF" : self = .OFF
        default :self = .ALL; print("unknown log level")
        }
    }
    
    func stringValue() -> String {
        
        switch self {
        case .ALL : return "ALL"
        case .DEBUG : return "DEBUG"
        case .INFO : return "INFO"
        case .WARN : return "WARN"
        case .ERROR : return "ERROR"
        case .FATAL : return "FATAL"
        case .OFF : return "OFF"
            
        }
    }

}

#if ISSWIFT
    open class RLLogManagerBase { }
#else
    open class RLLogManagerBase: NSObject { }
#endif

open class RLLogManager: RLLogManagerBase {
    
    private override init() { }
    
    internal var constants = Constants()
    
    static let sharedInstance = RLLogManager()
    var logQueue = RLQueue<RLLogModel>()
    var deviceUUID: String?
    let serialQueue = DispatchQueue(label: "com.enwidth.rologger", qos: .background)
    
    private var _logLevel  = RLLogLevel.ALL
    
    public static var logLevel : RLLogLevel {
        get {
            return RLLogManager.sharedInstance._logLevel
        }
        set {
            RLLogManager.sharedInstance._logLevel = newValue
        }
    }
    
    var apiKey = ""
    
    open class func initialize(apiKey:String) {
        RLLogManager.sharedInstance.apiKey = apiKey
        RLNetworkManager.sharedInstance.initialize()
        setupDeviceUUID()
    }
    
    open class func initialize(apiKey:String, serverUrl: String) {
        RLLogManager.sharedInstance.apiKey = apiKey
        RLLogManager.sharedInstance.constants.socketUrl = serverUrl
        RLNetworkManager.sharedInstance.initialize()
        setupDeviceUUID()
    }
    
    class func setupDeviceUUID() {
        let key = "com.enwidth.logger.deviceuuid";
        let defaults = UserDefaults.standard
        
        if let uuid = defaults.string(forKey: key) {
            RLLogManager.sharedInstance.deviceUUID = uuid
        }
        else {
            let uuid = UUID().uuidString
            RLLogManager.sharedInstance.deviceUUID = uuid
            defaults.setValue(uuid, forKey: key)
        }
    }
}
