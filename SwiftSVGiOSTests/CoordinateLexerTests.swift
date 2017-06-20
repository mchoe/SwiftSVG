//
//  CoordinateLexerTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class IteratorTests: XCTestCase {
    
    func testWhitespace() {
        var testString = " 0,40 40,40 40,80 80,80 80,120 120,120 120,160"
        var coordinateArray = [CGPoint]()
        var coordinateSequence = CoordinateLexer(coordinateString: testString)
        for thisPoint in coordinateSequence {
            coordinateArray.append(thisPoint)
        }
        XCTAssertTrue(coordinateArray[0].equalTo(CGPoint(x: 0, y: 40.0)), "Expected (0, 40), got \(coordinateArray[0])")
        XCTAssertTrue(coordinateArray[coordinateArray.count-1].equalTo(CGPoint(x: 120, y: 160.0)), "Expected (120, 160), got \(coordinateArray[coordinateArray.count-1])")
        
        coordinateArray.removeAll()
        testString = "0,40 40,40 40,80 80,80 80,120 120,120 120,160      "
        coordinateSequence = CoordinateLexer(coordinateString: testString)
        for thisPoint in coordinateSequence {
            coordinateArray.append(thisPoint)
        }
        XCTAssertTrue(coordinateArray[1].equalTo(CGPoint(x: 40, y: 40)), "Expected (40, 40), got \(coordinateArray[1])")
        XCTAssertTrue(coordinateArray[coordinateArray.count-2].equalTo(CGPoint(x: 120, y: 120.0)), "Expected (120, 120), got \(coordinateArray[coordinateArray.count-2])")
    }
    
}
