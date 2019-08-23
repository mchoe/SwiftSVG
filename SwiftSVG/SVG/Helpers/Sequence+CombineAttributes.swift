//
//  Sequence+CombineAttributes.swift
//  SwiftSVG
//
//  Created by khachapuri on 8/21/19.
//  Copyright © 2019 Strauss LLC. All rights reserved.
//

import Foundation

extension Sequence where Element: StoresAttributes {
    
    var combinedAttributes: [String : String] {
        return self
            .reduce([String : String](), { (old, new) -> [String : String] in
                return old
                    .merging(new.availableAttributes, uniquingKeysWith: { (current, _) -> String in
                        return current
                    })
            })
    }
    
}
