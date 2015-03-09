//
//  Stack.swift
//  Sprout
//
//  This file is from a dynamic framework I created called Sprout. I included the
//  files here so you didn't have to install another Cocoapod to use and test out
//  this library. As such, this file may not be maintained as well, so use it at
//  your own risk.
//
//  SwiftSVG is one of the many great tools that are a part of Sprout. If you're
//  looking for a great start to your next Swift project, check out Sprout.
//  It contains classes and helper functions that will get you started off right.
//  https://github.com/mchoe/Sprout
//
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
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

struct Stack<T> {
    var items = [T]()
    
    mutating func push(itemToPush: T) {
        self.items.append(itemToPush)
    }
    
    mutating func pop() -> T {
        return self.items.removeLast()
    }
}

extension Stack {
    var count: Int {
        get {
            return self.items.count
        }
    }
    
    var isEmpty: Bool {
        get {
            if self.items.count > 0 {
                return true
            }
            return false
        }
    }
    
    var last: T? {
        get {
            if self.isEmpty == false {
                return self.items.last
            }
            return nil
        }
    }
}