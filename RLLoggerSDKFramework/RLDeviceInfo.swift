//
//  RLDeviceInfo.swift
//  RLLoggerSDK
//
//  Created by Sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation
import UIKit

class RLDeviceInfo {
    
    var deviceName: String {
        return UIDevice.current.name
    }
    var apiKey: String {
        return RLLogManager.sharedInstance.apiKey
    }
    
    var deviceModel: String {
        return UIDevice.current.model
    }
    
    var platform: String {
        return UIDevice.current.systemName
    }
    
    var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var deviceUUID: String {
        return (UIDevice.current.identifierForVendor?.uuidString) ?? "Could not identify"
    }
    
    var deviceRamSize: UInt64 {
        return ((ProcessInfo.processInfo.physicalMemory/1024)/1024)
    }
    
    var currentRAMUsage: Float {
        return getCurrentRAMUsage()
    }
    
    func getCurrentRAMUsage() -> Float {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) { infoPtr in
            return infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { (machPtr: UnsafeMutablePointer<integer_t>) in
                return task_info(
                    mach_task_self(),
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    machPtr,
                    &count
                )
            }
        }
        guard kerr == KERN_SUCCESS else {
            return 0.0
        }
        return Float(info.resident_size) / (1024 * 1024)
    }
    
    func mach_task_self() -> task_t {
        return mach_task_self_
    }
    
    private func jsonString() ->String {
        
        let deviceInfoJson = """
            {
            "deviceName" : "\(deviceName)\",
            "deviceModel" : \"\(deviceModel)",
            "platform" : "\(platform)",
            "osVersion" : "\(osVersion)",
            "deviceRamSize" : "\(deviceRamSize)MB",
            "currentRamUsage" : "\(currentRAMUsage)MB"
            }
            """
        return deviceInfoJson
    }
    
    func logString() ->String {
        
        let strJson = """
        {
        "apiKey" : "\(RLLogManager.sharedInstance.apiKey)",
        "userType": "device",
        "deviceUUID" : "\(RLLogManager.sharedInstance.deviceUUID ?? "uuid not set")",
        "deviceInfo" : \(jsonString())
        }
        """
        return strJson
    }
}
