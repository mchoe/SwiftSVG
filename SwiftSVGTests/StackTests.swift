//
//  StackTests.swift
//  SwiftSVG
//
//  Created by tarragon on 7/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

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
