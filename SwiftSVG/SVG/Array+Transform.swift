//
//  Array+Transform.swift
//  SwiftSVG
//
//  Created by tarragon on 6/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation


extension Array {
    
    typealias Element = Transform
    
    init(transformString: String) {
        print("Parsing: \(transformString)")
        self.init()
    }
    
}
