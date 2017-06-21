//
//  SmoothCurveToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/20/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class SmoothCurveToTests: XCTestCase {

    func testAbsoluteSmoothCurveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [10, -20], pathType: .absolute, path: testPath)
        let curveTo = CurveTo(parameters: [78, -50, 37, 32, -18, 23], pathType: .absolute, path: testPath)
        _ = SmoothCurveTo(parameters: [66, 37, 39, -101, -78, 65], pathType: .absolute, path: testPath, previousCommand: curveTo)
        let pointsAndTypes = testPath.cgPath.pointsAndTypes
        XCTAssert(pointsAndTypes.last!.1 == .addCurveToPoint, "Expected .addCurveToPoint, got \(pointsAndTypes.last!.1)")
        
        XCTAssert(pointsAndTypes[4].1 == .addCurveToPoint, "Expected .addCurveToPoint, got \(pointsAndTypes[4].1)")
        //XCTAssert(pointsAndTypes[4].0.x == 66 && pointsAndTypes[4].0.y == 37, "Expected {66, 37}, got \(pointsAndTypes[4])")
        //XCTAssert(pointsAndTypes[6].0.x == 39 && pointsAndTypes[6].0.y == -101, "Expected {39, -101}, got \(pointsAndTypes[6])")
        //XCTAssert(pointsAndTypes[7].0.x == -78 && pointsAndTypes[7].0.y == 65, "Expected {-78, 65}, got \(pointsAndTypes[7])")
    }

}
