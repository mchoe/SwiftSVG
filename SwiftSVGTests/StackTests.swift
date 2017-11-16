//
//  StackTests.swift
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



import XCTest

class StackTests: XCTestCase {
    
    
    
    func testCount() {
        var testStack = Stack<Int>()
        testStack.push(1)
        testStack.push(10)
        XCTAssert(testStack.count == 2, "Expected 2, got \(testStack.count)")
    }
    
    func testLast() {
        var testStack = Stack<Float>()
        testStack.push(1.5)
        testStack.push(8.2)
        testStack.push(40.4)
        XCTAssert(testStack.last == 40.4, "Expected 40.4, got \(testStack.last!)")
    }
    
    func testClear() {
        var testStack = Stack<String>()
        testStack.push("Hello")
        testStack.push("There")
        testStack.clear()
        XCTAssert(testStack.count == 0, "Expected 0, got \(testStack.count)")
    }
    
    func testIsEmpty() {
        let testStack = Stack<String>()
        XCTAssert(testStack.isEmpty == true, "Expected empty stack, got \(testStack.items)")
    }
    
    func testPush() {
        var testStack = Stack<String>()
        testStack.push("hello")
        XCTAssert(testStack.last == "hello", "Expected \"hello\", got \(testStack.last!)")
    }
    
    func testPop() {
        var testStack = Stack<Character>()
        testStack.push(Character("a"))
        testStack.push(Character("b"))
        testStack.push(Character("c"))
        testStack.push(Character("d"))
        let poppedItem = testStack.pop()
        XCTAssert(poppedItem == "d", "Expected d, got \(poppedItem!)")
        XCTAssert(testStack.count == 3, "Expected count of 3, got \(testStack.count)")
    }
    
}
