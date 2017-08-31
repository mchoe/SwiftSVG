//
//  Stack.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.




import Foundation

/**
 A protocol that describes an instance that can act as a stack data structure
 */
protocol StackType {
    associatedtype StackItem
    var items: [StackItem] { get set }
    init()
    mutating func pop() -> StackItem?
    mutating func push(_ itemToPush: StackItem)
}

/**
 A stack data structure
 */
internal struct Stack<T>: StackType {
    var items = [T]()
    init() { }
}

extension StackType {
    
    /**
     Default implementation of popping the last element off the stack
     */
    @discardableResult
    mutating func pop() -> StackItem? {
        guard self.items.count > 0 else {
            return nil
        }
        return self.items.removeLast()
    }
    
    /**
     Push a new element on to the stack
     */
    mutating func push(_ itemToPush: StackItem) {
        self.items.append(itemToPush)
    }
    
    /**
     Clear all elements from the stack
     */
    mutating func clear() {
        self.items.removeAll()
    }
    
    /**
     Returns the number of elements on the stack
     */
    var count: Int {
        get {
            return self.items.count
        }
    }
    
    /**
     Check whether the stack is empty or not
     */
    var isEmpty: Bool {
        get {
            if self.items.count == 0 {
                return true
            }
            return false
        }
    }
    
    /**
     Return the last element on the stack without popping it off the stack. Equivalent to peek in other stack implementations 
     */
    var last: StackItem? {
        get {
            if self.isEmpty == false {
                return self.items.last
            }
            return nil
        }
    }
    
}
