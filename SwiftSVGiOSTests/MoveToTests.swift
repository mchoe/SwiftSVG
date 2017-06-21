//
//  MoveToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class MoveToTests: XCTestCase {

    func testAbsoluteMoveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path:testPath)
        XCTAssert(testPath.currentPoint.x == 20 && testPath.currentPoint.y == -30, "Expected {20, -30}, got \(testPath.currentPoint)")
        
        let firstPoint = testPath.cgPath.points[0]
        XCTAssert(firstPoint.x == 20 && firstPoint.y == -30, "Expected {20, -30}, got \(firstPoint)")
    }
    
    func testRelativeMoveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path:testPath)
        _ = LineTo(parameters: [55, -20], pathType: .absolute, path:testPath)
        _ = MoveTo(parameters: [50, -10], pathType: .relative, path:testPath)
        XCTAssert(testPath.currentPoint.x == 105 && testPath.currentPoint.y == -30, "Expected {105, -30}, got \(testPath.currentPoint)")
    }

}
