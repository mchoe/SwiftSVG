//
//  FillableTests.swift
//  SwiftSVG
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

class FillableTests: XCTestCase {
    
    func testFillOpacity() {
        let testShapeElement = TestShapeElement()
        testShapeElement.fill(fillColor: "#00FF33")
        testShapeElement.fillOpacity(opacity: "0.5")
        XCTAssert(testShapeElement.svgLayer.opacity == 1.0, "Fill opacity should be set on the CAShapelayer's fill color and not on the layer's overall opacity.")
        
        guard let fillComponents = testShapeElement.svgLayer.fillColor?.components else {
            XCTFail("Fill opacity should set the fill color")
            return
        }
        XCTAssert(fillComponents[3] == 0.5, "Expected 0.5, got \(fillComponents[3])")
    }
    
    func testFillOpacityOrder() {
        let testShapeElement = TestShapeElement()
        testShapeElement.fillOpacity(opacity: "0.5")
        testShapeElement.fill(fillColor: "#00FF00")
        
        guard let fillComponents = testShapeElement.svgLayer.fillColor?.components else {
            XCTFail("Fill should return color components")
            return
        }
        XCTAssert(fillComponents[3] == 0.5, "Fill color should preserve any existing fill opacity. Expected 0.5, got \(fillComponents[3])")
    }
    
    func testFillOpacityColorComponents() {
        let testShapeElement = TestShapeElement()
        testShapeElement.fill(fillColor: "#33FF66")
        testShapeElement.fillOpacity(opacity: "0.5")
        guard let fillComponents = testShapeElement.svgLayer.fillColor?.components else {
            XCTFail("Fill opacity should set the fill color")
            return
        }
        XCTAssert(testShapeElement.svgLayer.fillColor?.components![0] == 0.2, "Expected 0.0, got \(fillComponents[0])")
        XCTAssert(testShapeElement.svgLayer.fillColor?.components![1] == 1.0, "Expected 0.0, got \(testShapeElement.svgLayer.fillColor!.components![1])")
        XCTAssert(testShapeElement.svgLayer.fillColor?.components![2] == 0.4, "Expected 0.0, got \(testShapeElement.svgLayer.fillColor!.components![2])")
        XCTAssert(testShapeElement.svgLayer.fillColor?.components![3] == 0.5, "Expected 0.0, got \(testShapeElement.svgLayer.fillColor!.components![3])")
    }
    
}
