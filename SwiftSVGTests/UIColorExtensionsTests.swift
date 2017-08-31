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
        XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
        
        testString = "#FffF00"
        testColor = UIColor(hexString: testString)
        colorArray = self.colorArray(testColor!)
        XCTAssertTrue(colorArray[0] == 1, "Expected 1, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
        
        testString = "00fF00"
        testColor = UIColor(hexString: testString)
        colorArray = self.colorArray(testColor!)
        XCTAssertTrue(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 0, "Expected 0, got \(colorArray[2])")
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
        guard let testColor = UIColor(named: testString) else {
            XCTAssert(false, "Named color does not exist")
            return
        }
        var colorArray = self.colorArray(testColor)
        XCTAssertTrue(colorArray[0] == 0, "Expected 0, got \(colorArray[0])")
        XCTAssertTrue(colorArray[1] == 1, "Expected 1, got \(colorArray[1])")
        XCTAssertTrue(colorArray[2] == 1, "Expected 1, got \(colorArray[2])")
    }
    
}
