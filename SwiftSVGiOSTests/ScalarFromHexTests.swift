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
    
    func testBenchmarkStrtol() {
        self.measure {
            let testArray: [CChar] = [76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46, 100, 101, 76, 29, 80, 30, 13, 13, 46]
            let usingStrtol = CGFloat(byteArray: testArray)
        }
    }
    
    
    
}
