//
//  VerticalLineToTests.swift
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

class VerticalLineToTests: XCTestCase {

    func testAbsoluteVerticalLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = VerticalLineTo(parameters: [-128], pathType: .absolute, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[1].x == 10 && points[1].y == -128, "Expected {10, -128}, got \(points[1])")
    }
    
    func testRelativeVerticalLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = VerticalLineTo(parameters: [-128], pathType: .relative, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[1].x == 10 && points[1].y == -148, "Expected {10, -148}, got \(points[1])")
    }

}
