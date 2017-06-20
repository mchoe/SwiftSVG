//
//  MoveToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class MoveToTests: XCTestCase {

    func testBasicMoveTo() {
        
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path:testPath)
        XCTAssert(testPath.currentPoint.x == 20 && testPath.currentPoint.y == -30, "Expected 20, -30, got \(testPath.currentPoint)")
        
        let firstPoint = testPath.cgPath.points[0]
        XCTAssert(firstPoint.x == 20 && firstPoint.y == -30, "Expected 20, -30, got \(firstPoint)")
        
    }

}
