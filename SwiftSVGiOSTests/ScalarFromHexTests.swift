//
//  IntFromHexTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class ScalarFromHexTests: XCTestCase {
    
    func testStraightConversion() {
        var testString = "3D"
        var asInt = Int(hexString: testString)
        XCTAssertTrue(asInt == 61, "Expected 61, got \(asInt)")
        
        testString = "3d"
        asInt = Int(hexString: testString)
        XCTAssertTrue(asInt == 61, "Expected 61, got \(asInt)")
    }
    
    func testByteArray() {
        var testArray: [CChar] = [48, 65]
        var asFloat = CGFloat(byteArray: testArray)
        XCTAssert(asFloat == 10, "Expected 10, got \(asFloat)")
        
        testArray = [97, 98, 99, 100, 101, 102]
        asFloat = CGFloat(byteArray: testArray)
        XCTAssert(asFloat == 11259375, "Expected 11259375, got \(asFloat)")
        
        testArray = [70, 102]
        asFloat = CGFloat(byteArray: testArray)
        XCTAssert(asFloat == 255, "Expected 255, got \(asFloat)")
        
        testArray = [70, 70]
        asFloat = CGFloat(byteArray: testArray)
        XCTAssert(asFloat == 255, "Expected 255, got \(asFloat)")
        
        testArray = [69, 68]
        asFloat = CGFloat(byteArray: testArray)
        XCTAssert(asFloat == 237, "Expected 237, got \(asFloat)")
    }
    
    func testBenchmarkStrtol() {
        self.measure {
            let testArray: [CChar] = [76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46]
            let usingStrtol = CGFloat(byteArray: testArray)
        }
    }
    
    
    
}
