//
//  CurveToTests.swift
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

class CurveToTests: XCTestCase {

    func testAbsoluteCurveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(pathType: .absolute)
        _ = CurveTo(pathType: .absolute)
        let points = testPath.cgPath.points
        print(points)
        print(points.isEmpty)
        if (points.isEmpty) {
            XCTFail("Points array is empty")
        } else {
            XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
            XCTAssert(points[1].x == 66 && points[1].y == 37, "Expected 66, 37, got \(points[1])")
            XCTAssert(points[2].x == 32 && points[2].y == -18, "Expected 32, -18, got \(points[2])")
            XCTAssert(points[3].x == 23 && points[3].y == 98, "Expected 23, 98, got \(points[3])")
            XCTAssert(points[3].x == testPath.currentPoint.x && points[3].y == testPath.currentPoint.y, "Expected {\(testPath.currentPoint)}, got \(points[3])")
        }
    }
    
    func testRelativeCurveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(pathType: .absolute)
        _ = CurveTo(pathType: .relative)
        let points = testPath.cgPath.points
        if (points.isEmpty) {
            XCTFail("Points array is empty")
        } else {
            XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
            XCTAssert(points[1].x == 76 && points[1].y == 17, "Expected 76, 17, got \(points[1])")
            XCTAssert(points[2].x == 42 && points[2].y == -38, "Expected 42, -38, got \(points[2])")
            XCTAssert(points[3].x == 33 && points[3].y == 78, "Expected 33, 78, got \(points[3])")
            XCTAssert(points[3].x == testPath.currentPoint.x && points[3].y == testPath.currentPoint.y, "Expected {\(testPath.currentPoint)}, got \(points[3])")
        }
    }

}
