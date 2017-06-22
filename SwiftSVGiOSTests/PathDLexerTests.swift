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
        }
        XCTAssert(testPath.cgPath.pointsAndTypes[0].1 == .moveToPoint, "Expected MoveTo, got \(type(of: testPath.cgPath.pointsAndTypes[0].1))")
        XCTAssert(testPath.currentPoint.x == 80 && testPath.currentPoint.y == 45, "Expected {80, 45}, got \(testPath.currentPoint)")
    }
    
    func testNegativeMoveTo() {
        let testString = "M80-45z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
        }
        XCTAssert(testPath.cgPath.pointsAndTypes[0].1 == .moveToPoint, "Expected MoveTo, got \(type(of: testPath.cgPath.pointsAndTypes[0].1))")
        XCTAssert(testPath.currentPoint.x == 80 && testPath.currentPoint.y == -45, "Expected {80, -45}, got \(testPath.currentPoint)")
    }
    
    func testSpaceAsSeparator() {
        let testString = "M80 -45z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
        }
        XCTAssert(testPath.cgPath.pointsAndTypes[0].1 == .moveToPoint, "Expected MoveTo, got \(type(of: testPath.cgPath.pointsAndTypes[0].1))")
        XCTAssert(testPath.currentPoint.x == 80 && testPath.currentPoint.y == -45, "Expected {80, -45}, got \(testPath.currentPoint)")
    }
    
    func testMoreSpacesAsSeparator() {
        let testString = "M 47 -127 z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
        }
        XCTAssert(testPath.cgPath.pointsAndTypes[0].1 == .moveToPoint, "Expected MoveTo, got \(type(of: testPath.cgPath.pointsAndTypes[0].1))")
        XCTAssert(testPath.currentPoint.x == 47 && testPath.currentPoint.y == -127, "Expected {47, -127}, got \(testPath.currentPoint)")
    }
    
    func testMultipleClosePaths() {
        let testString = "M30-40L20,50z M10,20L80,90z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
        }
        //XCTAssert(testPath.cgPath.pointsAndTypes.last!.1 == .closeSubpath, "Expected .closeSubpath, got \(String(describing: testPath.cgPath.pointsAndTypes.last!.1))")
    }

}








