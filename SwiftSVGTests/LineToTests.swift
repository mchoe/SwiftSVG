//
//  LineToTests.swift
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

class LineToTests: XCTestCase {

    func testAbsoluteLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = LineTo(parameters: [66, 37], pathType: .absolute, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
        XCTAssert(points[1].x == 66 && points[1].y == 37, "Expected 66, 37, got \(points[1])")
    }
    
    func testRelativeLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = LineTo(parameters: [66, 37], pathType: .relative, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
        XCTAssert(points[1].x == 76 && points[1].y == 17, "Expected 76, 17, got \(points[1])")
    }

}
