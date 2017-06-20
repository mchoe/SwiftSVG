//
//  LineToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class LineToTests: XCTestCase {

    func testLineTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        _ = LineTo(parameters: [66, 37], pathType: .absolute, path: testPath)
        let points = testPath.cgPath.points
        XCTAssert(points[0].x == 10 && points[0].y == -20, "Expected 10, -20, got \(points[0])")
        XCTAssert(points[1].x == 66 && points[1].y == 37, "Expected 66, 37, got \(points[1])")
    }

}
