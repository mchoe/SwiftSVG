//
//  Print.swift
//  SwiftSVG
//
//  Created by khachapuri on 7/26/19.
//  Copyright © 2019 Strauss LLC. All rights reserved.
//

import Foundation

func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(item(), separator: separator, terminator: terminator)
    #endif
}
