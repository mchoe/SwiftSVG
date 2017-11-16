//
//  DictionaryAddTests.swift
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
