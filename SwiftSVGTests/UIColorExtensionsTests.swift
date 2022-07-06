//
//  UIColorExtensionsTests.swift
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
        var testColor: UIColor?
        var testString: String
        var colorArray: [CGFloat]
        
        testString = "#FFFF00"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
        } else {
            XCTFail("TestColor is nil")
        }
//        var colorArray = self.colorArray(testColor)
//        XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
//        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
//        XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
        
        testString = "#FffF00"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
        } else {
            XCTFail("TestColor is nil")
        }
        
        testString = "00fF00"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
        } else {
            XCTFail("TestColor is nil")
        }
    }
    
    func testHexStringWithAlpha() {
        var testString: String
        var testColor: UIColor?
        var colorArray: [CGFloat]
        
        testString = "#fcab1def"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 252 / 255, "Expected \(252 / 255), got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 171 / 255, "Expected \(171 / 255), got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 29 / 255, "Expected \(29 / 255), got \(colorArray[2])")
            XCTAssertTrue(colorArray[3] == 239 / 255, "Expected \(239 / 255), got \(colorArray[2])")
        } else {
            XCTFail("TestColor is nil")
        }
        
        testString = "a6bfc4d0"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 166 / 255, "Expected \(166 / 255), got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 191 / 255, "Expected \(191 / 255), got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 196 / 255, "Expected \(196 / 255), got \(colorArray[2])")
            XCTAssertTrue(colorArray[3] == 208 / 255, "Expected \(208 / 255), got \(colorArray[2])")
        } else {
            XCTFail("TestColor is nil")
        }

    }
    
    func testShortHexStrings() {
        var testString: String
        var testColor: UIColor?
        var colorArray: [CGFloat]
        testString = "#30f"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 0.2, "Expected 0.2, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 1.0, "Expected 1.0, got \(colorArray[2])")
        } else {
            XCTFail("TestColor is nil")
        }
        
        testString = "f033"
        testColor = UIColor(hexString: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 0.2, "Expected 0.2, got \(colorArray[2])")
            XCTAssertTrue(colorArray[3] == 0.2, "Expected 0.2, got \(colorArray[3])")
        } else {
            XCTFail("TestColor is nil")
        }
    }
    
    func testRGBString() {
        let testString = "rgb(255, 255, 0)"
        let testColor = UIColor(rgbString: testString)
        let colorArray = self.colorArray(testColor)
        XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
    }
    
    func testNamedColor() {
        let testString = "cyan"
        guard let testColor = UIColor(cssName: testString) else {
            XCTAssert(false, "Named color [\(testString)] does not exist")
            return
        }
        let colorArray = self.colorArray(testColor)
        XCTAssertTrue(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 1, "Expected 1, got \(colorArray[2])")
    }
    
    func testClearColors() {
        var testString: String
        var testColor: UIColor?
        var colorArray: [CGFloat]
        
        testString = "none"
        testColor = UIColor(cssName: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
            XCTAssertTrue(colorArray[3] == 0, "Expected 0, got \(colorArray[3])")
        } else {
            XCTFail("TestColor is nil")
        }
        
        testString = "transparent"
        testColor = UIColor(cssName: testString)
        if (testColor != nil) {
            colorArray = self.colorArray(testColor!)
            XCTAssertTrue(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
            XCTAssertTrue(colorArray[1] == 0, "Expected 0, got \(colorArray[1])")
            XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
            XCTAssertTrue(colorArray[3] == 0, "Expected 0, got \(colorArray[3])")
        } else {
            XCTFail("TestColor is nil")
        }
    }
    
}
