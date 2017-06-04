//
//  FloatingPointParseLengthTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class FloatingPointParseLengthTests: XCTestCase {
    
    func testStraightInteger() {
        let testNumber = Double(lengthString: "78")
        XCTAssertTrue(testNumber == 78, "Expected 78, got \(testNumber!)")
    }
    
    func testPixelAnnotation() {
        let testNumber = Double(lengthString: "890px")
        XCTAssertTrue(testNumber == 890, "Expected 890, got \(testNumber!)")
    }
    
    func testUnsupportedSuffix() {
        let testNumber = Float(lengthString: "123em")
        XCTAssertNil(testNumber, "Expected nil, got \(testNumber!)")
    }
    
}
