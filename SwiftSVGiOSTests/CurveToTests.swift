//
//  CurveToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class CurveToTests: XCTestCase {

    func testAbsoluteCurveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = CurveTo(parameters: [66, 37, 32, -18, 23, 98], pathType: .absolute, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
        XCTAssert(points[1].x == 66 && points[1].y == 37, "Expected 66, 37, got \(points[1])")
        XCTAssert(points[2].x == 32 && points[2].y == -18, "Expected 32, -18, got \(points[2])")
        XCTAssert(points[3].x == 23 && points[3].y == 98, "Expected 23, 98, got \(points[3])")
    }
    
    func testRelativeCurveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = CurveTo(parameters: [66, 37, 32, -18, 23, 98], pathType: .relative, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
        XCTAssert(points[1].x == 76 && points[1].y == 17, "Expected 76, 17, got \(points[1])")
        XCTAssert(points[2].x == 42 && points[2].y == -38, "Expected 42, -38, got \(points[2])")
        XCTAssert(points[3].x == 33 && points[3].y == 78, "Expected 33, 78, got \(points[3])")
    }

}
