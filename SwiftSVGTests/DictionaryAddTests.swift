//
//  DictionaryAddTests.swift
//  SwiftSVG
//
//  Created by tarragon on 7/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import XCTest

class DictionaryMergeTests: XCTestCase {
    
    var one = [
        "one": "one",
        "two": "two",
        "three": "three",
        "four": "four",
        "five": "five",
        "six": "six",
        "seven": "seven",
        "eight": "eight",
        "nine": "nine",
        "ten": "ten"
    ]
    var two = [
        "eleven": "eleven",
        "twelve": "twelve",
        "thirteen": "thirteen",
        "fourteen": "fourteen",
        "fifteen": "fifteen",
        "sixteen": "sixteen",
        "seventeen": "seventeen",
        "eighteen": "eighteen",
        "nineteen": "nineteen",
        "twenty": "twenty",
        ]
    
    func testForEach() {
        self.measure {
            self.two.forEach{
                self.one[$0] = $1
            }
        }
    }
    
    func testForIn() {
        self.measure {
            for (key, value) in self.two {
                self.one[key] = value
            }
        }
    }
    
    func testMerge() {
        self.one.add(self.two)
        XCTAssert(self.one.count == 20, "Expected 20, got \(self.one.count)")
        XCTAssert(self.one["twenty"] == "twenty", "Expected \"twenty\", got \(self.one["twenty"]!)")
    }
    
    
}
