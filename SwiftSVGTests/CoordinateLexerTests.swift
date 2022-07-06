//
//  CoordinateLexerTests.swift
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
@testable
import SwiftSVG

class IteratorTests: XCTestCase {
    
    func testWhitespace() {
        var testString = " 0,40 40,40 40,80 80,80 80,120 120,120 120,160"
        var coordinateArray = [CGPoint]()
        var coordinateSequence = CoordinateLexer(coordinateString: testString)
        for thisPoint in coordinateSequence {
            coordinateArray.append(thisPoint)
        }
        XCTAssertTrue(coordinateArray[0].equalTo(CGPoint(x: 0, y: 40.0)), "Expected (0, 40), got \(coordinateArray[0])")
        XCTAssertTrue(coordinateArray[coordinateArray.count-1].equalTo(CGPoint(x: 120, y: 160.0)), "Expected (120, 160), got \(coordinateArray[coordinateArray.count-1])")
        
        coordinateArray.removeAll()
        testString = "0,40 40,40 40,80 80,80 80,120 120,120 120,160      "
        coordinateSequence = CoordinateLexer(coordinateString: testString)
        for thisPoint in coordinateSequence {
            coordinateArray.append(thisPoint)
        }
        XCTAssertTrue(coordinateArray[1].equalTo(CGPoint(x: 40, y: 40)), "Expected (40, 40), got \(coordinateArray[1])")
        XCTAssertTrue(coordinateArray[coordinateArray.count-2].equalTo(CGPoint(x: 120, y: 120.0)), "Expected (120, 120), got \(coordinateArray[coordinateArray.count-2])")
    }
    
}
