//
//  IteratorTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class IteratorTests: XCTestCase {
    
    func testWhitespace() {
        var testString = " 0,40 40,40 40,80 80,80 80,120 120,120 120,160"
        var coordinateSequence = CoordinateSequence(coordinateString: testString)
        XCTAssertTrue(CGPointEqualToPoint(coordinateSequence[0], CGPoint(0, 40), "Expected (0, 40), got \(coordinateSequence[0])")
    }
    
}
