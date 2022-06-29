//
//  IndentifiableTests.swift
//  SwiftSVGTests
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

class IndentifiableTests: XCTestCase {
    
    func testShapeElementSetsLayerName() {
        let testShapeElement = TestShapeElement()
        testShapeElement.identify(identifier: "id-to-check")
        XCTAssert(testShapeElement.svgLayer.name == "id-to-check", "Expected \"id-to-check\", got: \(String(describing: testShapeElement.svgLayer.name))")
    }
    
    func testEndToEnd() {
        
        guard let resourceURL = Bundle(for: type(of: self)).url(forResource: "simple-rectangle", withExtension: "svg") else {
            XCTAssert(false, "Couldn't find resource")
            return
        }
        
        let asData = try! Data(contentsOf: resourceURL)
        let expectation = self.expectation(description: "Identifiable expectation")
        _ = UIView(svgData: asData) { (svgLayer) in
            guard let rootLayerName = svgLayer.sublayers?[0].name else {
                return
            }
            guard rootLayerName == "root-rectangle-id" else {
                return
            }
            
            guard let innerID = svgLayer.sublayers?[0].sublayers?[0].name else {
                return
            }
            guard innerID == "inner-rectangle-id" else {
                return
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 3, handler: nil)
        
    }
    
}
