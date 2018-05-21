//
//  RLQueue.swift
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

import Foundation

class RLQueue<T> {
    fileprivate var array = [T]()
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    func enqueue(_ element: T) {
        array.append(element)
    }
    
    func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    func dequeue(n: Int) -> [T]? {
        if isEmpty {
            return nil
        } else {
            let tmpArray = array[0..<n]
            array.removeFirst(n)
            return Array<T>(tmpArray)
        }
    }

    
    var front: T? {
        return array.first
    }
}
