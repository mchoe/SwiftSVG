//
//  CGFloat+Extensions.swift
//  SwiftSVGiOS
//
//  Created by Michael Choe on 6/6/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    
    init?(_ string: String) {
        guard let asDouble = Double(string) else {
            return nil
        }
        self.init(asDouble)
    }
    
}
