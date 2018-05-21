//
//  RLOfflineLogManager.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

class RLOfflineLogManager {
    
    var latestLogFilePath: URL?
    
    var logFilePathToProcess: URL?
    {
        didSet {
            if logFilePathToProcess == nil {
                isOfflineLogsPresent = false
            }
            else {
                isOfflineLogsPresent = true
            }
        }
    }
    
    var logDirectoryPath : URL?
    var timer: DispatchSourceTimer?
    var isOfflineLogsPresent = false
    
    private init () {
        logDirectoryPath = self.initializeLogDirectory()
        initializeLogFile()
    }
    
    let queue = DispatchQueue(label: "com.enwidth.logsenderfile", qos: .background)

    
    static let sharedInstance = RLOfflineLogManager()
    
    
    func initializeLogDirectory() -> URL {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        let dirPath = documentsUrl.appendingPathComponent("RLogs")
        
        if (FileManager.default.fileExists(atPath: dirPath.path) == false) {
            do {
                try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }

        return dirPath
    }
    
    func initializeLogFile()  {
        
        var files: [String]?
        
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: (logDirectoryPath?.path)!)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        if let fileName = (files?.flatMap { Int($0) })?.max() {
            latestLogFilePath = logDirectoryPath?.appendingPathComponent(String(fileName))
        }
        else {
            latestLogFilePath = nil
        }
        
        if let fileName = (files?.flatMap { Int($0) })?.min(){
            logFilePathToProcess = logDirectoryPath?.appendingPathComponent(String(fileName))
        }
        else {
            logFilePathToProcess = nil
        }
    }
    
    
    func sizeOfFile(path:String) -> UInt64 {
        
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(path)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(path) with error: \(error)")
        }
        
        return 0
    }
    
    
    func writeLogToFile(logText:String) {
        
        if (latestLogFilePath == nil) {
            latestLogFilePath = createLogFile()
        }
        
        let fileSize = sizeOfFile(path: latestLogFilePath!.path)
        
        if (fileSize > Constants.logFileSizeLimit) {
            latestLogFilePath = createLogFile()
        }
        
        if (logFilePathToProcess == nil) {
            logFilePathToProcess = latestLogFilePath
        }
        
        if let fileHandle = try? FileHandle(forWritingTo: latestLogFilePath!) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(logText.data(using: .utf8)!)
            fileHandle.closeFile()
            //TODO: persist file handler
        }
    }
    
    func logsToSend() -> String? {
        
        var logText: String?
        
        if (logFilePathToProcess == nil) {
            initializeLogFile()
        }
        
        if let path = logFilePathToProcess {
            
            logText = try? String(contentsOf: path)
        }
        else {
            print("log file is empty to read")
        }
        
        return logText
    }
    
    func deleteProcessedLogFile() {
        
        if let path = logFilePathToProcess{
            do {
                try FileManager.default.removeItem(at: path)
            }
            catch let error {
                print("Error while deleting log file " + error.localizedDescription)
            }
        }
        
        initializeLogFile()
    }
    
    func createLogFile() -> URL? {
        let fileName = Int(Date().timeIntervalSince1970*1000000)
        let filePath  = logDirectoryPath?.appendingPathComponent(String(fileName))
        
        if (FileManager.default.createFile(atPath: (filePath?.path)!, contents: nil, attributes: nil) == false) {
            print("error while creating log file")
        }
        
        return filePath
    }
}
