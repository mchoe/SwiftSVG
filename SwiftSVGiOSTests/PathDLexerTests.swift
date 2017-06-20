//
//  PathDLexerTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class PathDLexerTests: XCTestCase {

    func testBasicMoveTo() {
        let testString = "M80,45z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
            XCTAssert(thisCommand is MoveTo, "Expected MoveTo, got \(type(of: thisCommand))")
        }
        XCTAssert(testPath.currentPoint.x == 80 && testPath.currentPoint.y == 45, "Expected {80, 45}, got \(testPath.currentPoint)")
    }
    
    func testNegativeMoveTo() {
        let testString = "M80-45z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
            XCTAssert(thisCommand is MoveTo, "Expected MoveTo, got \(type(of: thisCommand))")
        }
        XCTAssert(testPath.currentPoint.x == 80 && testPath.currentPoint.y == -45, "Expected {80, -45}, got \(testPath.currentPoint)")
    }
    
    func testSpaceAsSeparator() {
        let testString = "M80 -45z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
            XCTAssert(thisCommand is MoveTo, "Expected MoveTo, got \(type(of: thisCommand))")
        }
        XCTAssert(testPath.currentPoint.x == 80 && testPath.currentPoint.y == -45, "Expected {80, -45}, got \(testPath.currentPoint)")
    }
    
    func testMoreSpacesAsSeparator() {
        let testString = "M 47 -127 z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
            XCTAssert(thisCommand is MoveTo, "Expected MoveTo, got \(type(of: thisCommand))")
        }
        XCTAssert(testPath.currentPoint.x == 47 && testPath.currentPoint.y == -127, "Expected {47, -127}, got \(testPath.currentPoint)")
    }

}








