//
//  PathDLexerTests.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



import XCTest
@testable
import SwiftSVG

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
        XCTAssert(testPath.cgPath.pointsAndTypes[2].1 == .closeSubpath, "Expected .closeSubpath, got \(String(describing: testPath.cgPath.pointsAndTypes[2].1))")
        XCTAssert(testPath.cgPath.pointsAndTypes.last!.1 == .closeSubpath, "Expected .closeSubpath, got \(String(describing: testPath.cgPath.pointsAndTypes.last!.1))")
    }
    
    func testNoSubsequentCharacter() {
        let testString = "m193.2 162.44c4.169 0 8.065 0.631 12.327 0.631 3.391 0 7.062-0.404 10.427 0 0.881 0.105 3.056 0.187 3.793 0.633 1.551 0.939 1.013 0.261 1.265 2.527 0.164 1.476 0 3.078 0 4.565 0 1.211-0.826 6.618-0.315 7.129 1.238 1.238 5.366 2.607 7.269 3.476 2.513 1.146 4.488 2.562 6.952 3.793 2.435 1.217 5.177 1.804 4.426 4.424-0.364 1.271-1.808 2.668-2.529 3.793-0.438 0.684-2.528 3.339-2.528 4.109 0 0.606-13.593-2.429-15.17-2.846-2.26-0.598-5.387-0.692-6.004-3.16-0.631-2.525-0.661-5.73-0.949-8.217-0.358-3.095 1.059-6.32-2.844-6.32-2.102 0-5.384 0.628-7.269-0.316-1.008-0.505-2.737 0.105-3.476-0.632-0.979-0.977-1.59-1.802-2.214-3.478-1.23-3.25-2.25-6.73-3.17-10.1"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
        }
    }
    
    func testLeadingPoint() {
        let testString = "M1.5.5z"
        let testPath = UIBezierPath()
        for thisCommand in PathDLexer(pathString: testString) {
            thisCommand.execute(on: testPath, previousCommand: nil)
        }
        XCTAssert(testPath.cgPath.pointsAndTypes[0].1 == .moveToPoint, "Expected MoveTo, got \(type(of: testPath.cgPath.pointsAndTypes[0].1))")
        XCTAssert(testPath.currentPoint.x == 1.5 && testPath.currentPoint.y == 0.5, "Expected {1.5, 0.5}, got \(testPath.currentPoint)")
    }
}








