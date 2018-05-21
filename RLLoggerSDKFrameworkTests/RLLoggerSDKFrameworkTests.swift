//
//  RLLoggerSDKFrameworkTests.swift
//  RLLoggerSDKFrameworkTests
//
//  Created by Sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import XCTest
@testable import RLLoggerSDKFramework

class RLLoggerSDKFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        RLLogManager.initialize(apiKey: "122222")
        RLLogManager.logLevel = .DEBUG
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFrameworkQueue() {
        RLog.debug("hii")
        RLog.debug("hii this")
        RLog.debug("hii this is ")
        RLog.debug("hii this is Test ")
        RLog.debug("hii this is Test Message Log")
        RLog.debug("hii this is Test Message Log from ")
        RLog.debug("hii this is Test Message Log from Unit testcases")
        
        XCTAssertEqual(RLNetworkManager.sharedInstance.isExecuting , false)
    }
    
    func testRLLogModelCreationUsingMessage() {
        let message = "Hii, this is a test message log for checking"
        let RLLogModel_instance = RLLogModel(messages: message)
        let jsonvalue = RLLogModel_instance.jsonString()
        XCTAssert(jsonvalue.contains(message), "RLLogmodel instance created with correct message")
    }
    
    func testRLLogModelCreationUsingMessageAndKeyword() {
        let message = "Hii, this is a test message log for checking creation of RllogModel object"
        let keyWord = "RLLogModelCreation"
        let jsonValue = RLLogModel(messages: message, keywords: keyWord).jsonString()
        XCTAssertEqual(jsonValue.contains(message), jsonValue.contains(keyWord))
    }
    
    func testChangeLevel() {
        RLLogManager.logLevel = .ERROR
        let jsonvalue = RLLogModel(messages: "Changing Loglevel").jsonString()
        XCTAssert(jsonvalue.contains("ERROR"), "Changed loglevel")
    }
    
    func testNumberOfLogs() {
        
        var count = 0
        for number in 0...10 {
            count += 1
            RLog.debug("\(number)" + "times this message log has been sent to socket")
        }
        print("number of times log called is  \(count)")
        print(RLLogManager.sharedInstance)
        sleep(10)
        print(RLLogManager.sharedInstance.logQueue.count)
        
        XCTAssertEqual(RLLogManager.sharedInstance.logQueue.count, count)
    }
    
    func testEnqueueLogs() {
        var count = 0
        for number in 0...10 {
            count += 1
            RLog.debug("\(number)" + "times this message log has been sent to socket")
        }
        
        sleep(5)
        
        print(RLLogManager.sharedInstance.logQueue.dequeue(n: RLLogManager.sharedInstance.logQueue.count)!)
        
        XCTAssertEqual(RLLogManager.sharedInstance.logQueue.count, 0)
    }
    
    func testCreatingFileAfterQueueLimit() {
        var count = 0
        for number in 0...Constants.logQueueLimit {
            count += 1
            RLog.debug("\(number)" + "times this message log has been sent to socket")
        }
        sleep(5)
        print("Count of Logqueue - \(RLLogManager.sharedInstance.logQueue.count)")
    }
    
    func testDeviceInfo() {
        let deviceInfo = RLDeviceInfo().jsonString()
        print(deviceInfo)
    }
    
    func testFileCreation() {
        RLNetworkManager.sharedInstance.isNetworkReachable = false
        var isFileCreated = false
        
        if RLLogManager.sharedInstance.logQueue.count > Constants.logQueueLimit {
            if let fileurl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let folderUrl = fileurl.appendingPathComponent("RLogs")
                if FileManager.default.fileExists(atPath: folderUrl.path) {
                    isFileCreated = true
                }
            }
        }
        XCTAssert(isFileCreated, "File created at document directory")
    }
}

   
