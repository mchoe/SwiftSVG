//
//  PerformanceTests.swift
//  SwiftSVG
//
//  Created by tarragon on 6/26/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class PerformanceTests: XCTestCase {

    func testSwiftSVG() {
        self.measure {
            if let resourceURL = Bundle.main.url(forResource: "washington", withExtension: "svg") {
                _ = CAShapeLayer(SVGURL: resourceURL)
            }
        }
    }

}
