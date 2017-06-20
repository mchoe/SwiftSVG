//
//  ClosePathTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/20/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class ClostPathTests: XCTestCase {

    func testClosePath() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path:testPath)
        _ = ClosePath(parameters: [], pathType: .absolute, path:testPath)
        let lastPointAndType = testPath.cgPath.pointsAndTypes.last!
        XCTAssert(lastPointAndType.1 == .closeSubpath, "Expected .closeSubpath, got \(lastPointAndType.1)")
        XCTAssert(lastPointAndType.0.x == 20 && lastPointAndType.0.y == -30, "Expected 20, -30, got \(lastPointAndType.0)")
    }

}
