//
//  UIColorExtensionsTests.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class UIColorExtensionsTests: XCTestCase {
    
    func testRGBString() {
        let testString = "rgb(255, 255, 0)"
        let testColor = UIColor(rgbString: testString)
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var alpha = CGFloat()
        testColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertTrue(red == 1, "Expected 1, got \(red)")
        XCTAssertTrue(green == 1, "Expected 1, got \(green)")
        XCTAssertTrue(blue == 0, "Expected 1, got \(blue)")
    }
    
}
