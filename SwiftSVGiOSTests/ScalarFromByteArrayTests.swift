//
//  ScalarFromByteArrayTests.swift
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

class ScalarFromByteArrayTests: XCTestCase {

    func testByteArray() {
        var testArray: [CChar] = [49, 48]
        var asDouble = Double(byteArray: testArray)!
        XCTAssert(asDouble == 10, "Expected 10, got \(asDouble)")
        
        testArray = [45, 57, 49, 53]
        asDouble = Double(byteArray: testArray)!
        XCTAssert(asDouble == -915, "Expected -915, got \(asDouble)")
        
        testArray = [45, 54, 46, 51, 56]
        asDouble = Double(byteArray: testArray)!
        XCTAssert(asDouble == -6.38, "Expected -6.38, got \(asDouble)")
    }
    
    func testInvalidByteArray() {
        var testArray: [CChar] = [65, 48]       // "A0"
        var asDouble = Double(byteArray: testArray)
        XCTAssertNil(asDouble, "Expected nil, got \(String(describing: asDouble))")
        
        testArray = []
        asDouble = Double(byteArray: testArray)
        XCTAssertNil(asDouble, "Expected nil, got \(String(describing: asDouble))")
    }
    
    func testENumber() {
        let testArray: [CChar] = [49, 101, 51] // "1e3
        let asDouble = Double(byteArray: testArray)
        XCTAssert(asDouble == 1000, "Double: \(asDouble!)")
    }
    
    func testZeroCountArray() {
        let testArray = [CChar]()
        let asDouble = Double(byteArray: testArray)
        XCTAssertNil(asDouble, "Expected nil, got \(String(describing: asDouble))")
    }

}
