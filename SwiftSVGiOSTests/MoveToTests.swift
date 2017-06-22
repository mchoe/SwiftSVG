//
//  MoveToTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/19/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class MoveToTests: XCTestCase {

    func testAbsoluteMoveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path:testPath)
        XCTAssert(testPath.currentPoint.x == 20 && testPath.currentPoint.y == -30, "Expected {20, -30}, got \(testPath.currentPoint)")
        
        let firstPoint = testPath.cgPath.points[0]
        XCTAssert(firstPoint.x == 20 && firstPoint.y == -30, "Expected {20, -30}, got \(firstPoint)")
    }
    
    func testRelativeMoveTo() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path:testPath)
        _ = LineTo(parameters: [55, -20], pathType: .absolute, path:testPath)
        _ = MoveTo(parameters: [50, -10], pathType: .relative, path:testPath)
        XCTAssert(testPath.currentPoint.x == 105 && testPath.currentPoint.y == -30, "Expected {105, -30}, got \(testPath.currentPoint)")
    }
    
    func testRelativeFirstMoveToTreatedAsAbsolute() {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [50, 30], pathType: .relative, path: testPath, previousCommand: nil)
        XCTAssert(testPath.currentPoint.x == 50 && testPath.currentPoint.y == 30, "Expected {50, 30}, got \(testPath.currentPoint)")
    }
    
    func testMultipleMoveToCommands() {
        let testPath = UIBezierPath()
        let moveTo1 = MoveTo(parameters: [10, 20], pathType: .relative, path: testPath)
        let moveTo2 = MoveTo(parameters: [30, 40], pathType: .relative, path: testPath, previousCommand: moveTo1)
        _ = MoveTo(parameters: [70, 80], pathType: .absolute, path: testPath, previousCommand: moveTo2)
        
        let pointsAndTypes = testPath.cgPath.pointsAndTypes
        XCTAssert(pointsAndTypes[0].1 == .moveToPoint, "Expected .moveToPoint, got \(pointsAndTypes[0].1)")
        XCTAssert(pointsAndTypes[1].1 == .addLineToPoint, "Expected .addLineToPoint, got \(pointsAndTypes[1].1)")
        XCTAssert(pointsAndTypes[2].1 == .addLineToPoint, "Expected .addLineToPoint, got \(pointsAndTypes[2].1)")
        
        XCTAssert(pointsAndTypes[0].0.x == 10 && pointsAndTypes[0].0.y == 20, "Expected {10, 20}, got \(pointsAndTypes[0].0)")
        XCTAssert(pointsAndTypes[1].0.x == 40 && pointsAndTypes[1].0.y == 60, "Expected {40, 60}, got \(pointsAndTypes[1].0)")
        XCTAssert(pointsAndTypes[2].0.x == 70 && pointsAndTypes[2].0.y == 80, "Expected {70, 80}, got \(pointsAndTypes[2].0)")
        
    }

}
