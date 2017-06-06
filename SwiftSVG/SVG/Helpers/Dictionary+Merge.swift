//
//  Dictionary+Merge.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public mutating func add(_ dictionary: [Key:Value]) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
}
