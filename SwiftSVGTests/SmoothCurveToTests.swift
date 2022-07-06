//
//  SmoothCurveToTests.swift
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

class SmoothCurveToTests: XCTestCase {

    func testAbsoluteSmoothCurveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(pathType: .absolute)
        _ = CurveTo(pathType: .absolute)
        _ = SmoothCurveTo(pathType: .absolute)
        let pointsAndTypes = testPath.cgPath.pointsAndTypes
        if (pointsAndTypes.isEmpty) {
            XCTFail("PointsAndTypes array is empty")
        } else {
            XCTAssert(pointsAndTypes.last!.1 == .addCurveToPoint, "Expected .addCurveToPoint, got \(pointsAndTypes.last!.1)")
            
            XCTAssert(pointsAndTypes[4].1 == .addCurveToPoint, "Expected .addCurveToPoint, got \(pointsAndTypes[4].1)")
            //XCTAssert(pointsAndTypes[4].0.x == 66 && pointsAndTypes[4].0.y == 37, "Expected {66, 37}, got \(pointsAndTypes[4])")
            //XCTAssert(pointsAndTypes[6].0.x == 39 && pointsAndTypes[6].0.y == -101, "Expected {39, -101}, got \(pointsAndTypes[6])")
            //XCTAssert(pointsAndTypes[7].0.x == -78 && pointsAndTypes[7].0.y == 65, "Expected {-78, 65}, got \(pointsAndTypes[7])")
        }
    }

}
