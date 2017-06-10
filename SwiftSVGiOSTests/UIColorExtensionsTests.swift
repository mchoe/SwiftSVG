//
//  UIColorExtensionsTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class UIColorExtensionsTests: XCTestCase {
    
    func colorArray(_ color: UIColor) -> [CGFloat] {
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var alpha = CGFloat()
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red, green, blue, alpha]
    }
    
    func testHexString() {
        var testString = "#FFFF00"
        var testColor = UIColor(hexString: testString)
        var colorArray = self.colorArray(testColor!)
        XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 1, got \(colorArray[2])")
        
        testString = "#FffF00"
        testColor = UIColor(hexString: testString)
        colorArray = self.colorArray(testColor!)
        XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 1, got \(colorArray[2])")
        
        testString = "00fF00"
        testColor = UIColor(hexString: testString)
        colorArray = self.colorArray(testColor!)
        XCTAssertTrue(colorArray[0] == 0, "Expected 1, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 1, got \(colorArray[2])")
    }
    
    func testRGBString() {
        let testString = "rgb(255, 255, 0)"
        let testColor = UIColor(rgbString: testString)
        let colorArray = self.colorArray(testColor)
        XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 1, got \(colorArray[2])")
    }
    
}
