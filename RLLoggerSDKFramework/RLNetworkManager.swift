//
//  RLNetworkManager.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation
import Starscream

class RLNetworkManager {
    
    var isExecuting = false
    
    private init () { }
    
    internal func initialize() {
        timer = DispatchSource.makeTimerSource(queue: self.queue)

        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(2))
        
        timer?.setEventHandler(handler: {
        self.sendLogs()
        })
        timer?.resume()
        
        configureReachability()
        establishConnection()
    }
    
    let reachability = RLReachability()!
    var isNetworkReachable = true
    
    static let sharedInstance = RLNetworkManager()
    let queue = DispatchQueue(label: "com.enwidth.logsender", qos: .background)
    var timer: DispatchSourceTimer?
    
    
    let socket = WebSocket(url: URL(string: RLLogManager.sharedInstance.constants.socketUrl)!)
    
    func establishConnection() {
//        socket.delegate = self
//        socket.connect()
        
        socket.onConnect = {
            print("websocket is connected")
            self.socket.write(string: "Hi Server!")
            self.socket.write(string: RLDeviceInfo().logString())
        }
        //websocketDidDisconnect
        socket.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(error?.localizedDescription)")
        }
        //websocketDidReceiveMessage
        socket.onText = { (text: String) in
            print("got some text: \(text)")
        }
        //websocketDidReceiveData
        socket.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }
        //you could do onPong as well.
        socket.connect()
        
    }
    
//    func websocketDidConnect(socket: WebSocket) {
//        print("websocket is connected")
//        socket.write(string: "Hi Server!")
//        socket.write(string: RLDeviceInfo().jsonString())
//
//    }
//
//    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
//        print("got some text: \(text)")
//    }
//
//    func websocketDidReceiveData(socket: WebSocket, data: Data) {
//        print("got some data: \(data.count)")
//    }
//
//    func websocketDidReceivePong(socket: WebSocket, data: Data?) {
//        print("Got pong! Maybe some data: \(String(describing: data?.count))")
//    }
    
    func configureReachability() {
        
        reachability.whenReachable = { reachability in
            self.isNetworkReachable = true
            print("network reachable")
        }
        reachability.whenUnreachable = { reachability in
            self.isNetworkReachable = false
            print("network not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    func sendLogs() {
        self.queue.async {
            
            if (self.isExecuting == false) {
                
                self.isExecuting = true
                
                let logQueue = RLLogManager.sharedInstance.logQueue
                
                if self.socket.isConnected &&
                    self.isNetworkReachable
                {
                    if (RLOfflineLogManager.sharedInstance.isOfflineLogsPresent == true) {
                        
                        if let logText = RLOfflineLogManager.sharedInstance.logsToSend() {
                            self.socket.write(string: logText, completion: {
                                RLOfflineLogManager.sharedInstance.deleteProcessedLogFile()
                                self.sendLogs()
                            })
                        }
                        else {
                            self.sendLogs()
                        }
                    }
                    else {
                        if let logText = logQueue.dequeue()?.logString() {
                            self.socket.write(string: logText, completion: {
                                self.sendLogs()
                            })
                        }
                    }
                }
                else if self.isNetworkReachable && self.socket.isConnected == false {
                    self.socket.connect()
                }
                
                if (logQueue.count > Constants.logQueueLimit) {
                    
                    let backlogs = logQueue.dequeue(n: Constants.logQueueLimit)
                    var logText = ""
                    
                    backlogs?.forEach({ (log:RLLogModel) in
                        logText = logText + log.logString() + "\n"
                    })
                    
                    RLOfflineLogManager.sharedInstance.writeLogToFile(logText: logText)
                }
                
                self.isExecuting = false
            }
        }
    }
    
}
