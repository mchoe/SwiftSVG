//
//  HorizontalLineToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/20/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class HorizontalLineToTests: XCTestCase {

    func testAbsoluteHorizontalLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = HorizontalLineTo(parameters: [-128], pathType: .absolute, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[1].x == -128 && points[1].y == -20, "Expected {-128, -20}, got \(points[1])")
    }
    
    func testRelativeHorizontalLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = HorizontalLineTo(parameters: [-128], pathType: .relative, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[1].x == -118 && points[1].y == -20, "Expected {-118, -20}, got \(points[1])")
    }

}
