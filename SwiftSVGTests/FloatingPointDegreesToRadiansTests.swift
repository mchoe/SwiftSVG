//
//  FloatingPointDegreesToRadiansTests.swift
//  SwiftSVG
//
//  Created by tarragon on 7/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class FloatingPointDegreesToRadiansTests: XCTestCase {
    
    func testToRadians() {
        let degrees: Double = 180.0
        XCTAssert(degrees.toRadians == Double.pi, "Expected pi, got \(degrees.toRadians)")
    }
    
    func testToDegrees() {
        let radians: Double = Double.pi
        XCTAssert(radians.toDegrees == 180, "Expected 180, got \(radians.toDegrees)")
    }
    
}
