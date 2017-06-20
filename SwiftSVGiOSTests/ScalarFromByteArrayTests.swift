//
//  ScalarFromByteArrayTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class ScalarFromByteArrayTests: XCTestCase {

    func testByteArray() {
        var testArray: [CChar] = [49, 48]
        var asDouble = Double(byteArray: testArray)!
        XCTAssert(asDouble == 10, "Expected 10, got \(asDouble)")
        
        testArray = [45, 57, 49, 53]
        asDouble = Double(byteArray: testArray)!
        XCTAssert(asDouble == -915, "Expected -915, got \(asDouble)")
        
        testArray = [45, 54, 46, 51, 56]
        asDouble = Double(byteArray: testArray)!
        XCTAssert(asDouble == -6.38, "Expected -6.38, got \(asDouble)")
    }
    
    func testInvalidByteArray() {
        var testArray: [CChar] = [65, 48]       // "A0"
        var asDouble = Double(byteArray: testArray)
        XCTAssertNil(asDouble, "Expected nil, got \(asDouble)")
        
        testArray = []
        asDouble = Double(byteArray: testArray)
        XCTAssertNil(asDouble, "Expected nil, got \(asDouble)")
    }

}
