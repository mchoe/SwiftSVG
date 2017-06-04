//
//  IntFromHexTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class IntFromHexTests: XCTestCase {
    
    func testStraightConversion() {
        var testString = "3D"
        var asInt = Int(hexString: testString)
        XCTAssertTrue(asInt == 61, "Expected 61, got \(asInt)")
        
        testString = "3d"
        asInt = Int(hexString: testString)
        XCTAssertTrue(asInt == 61, "Expected 61, got \(asInt)")
    }
    
}
