//
//  SVGCircleTests.swift
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

class SVGCircleTests: XCTestCase {

    func testElementName() {
        XCTAssert(SVGCircle.elementName == "circle", "Expected \"circle\", got \(SVGCircle.elementName)")
    }
    
    func testSettingValues () {
        let testCircle = SVGCircle()
        testCircle.xCenter(x: "40.3")
        testCircle.yCenter(y: "108.254")
        
        XCTAssert(testCircle.circleCenter == CGPoint(x: 40.3, y: 108.254), "Expected {40.3, 108.254}, got \(testCircle.circleCenter)")
        
        testCircle.radius(r: "435.10")
        XCTAssert(testCircle.circleRadius == 435.1, "Expected 435.1, got \(testCircle.circleRadius)")
        
        testCircle.radius(r: "1e3")
        XCTAssert(testCircle.circleRadius == 1000, "Expected 1000, got \(testCircle.circleRadius)")
    }

}
