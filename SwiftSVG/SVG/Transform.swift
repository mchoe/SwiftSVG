//
//  Transform.swift
//  SwiftSVG
//
//  Created by tarragon on 6/22/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


enum Transform {
    case translate
}

protocol Transformable { }

extension Transformable {
    
    var transformAttributes: [String : (CGPoint) -> ()] {
        return [
            "transform": self.translate,
        ]
    }
    
    func transform(_ transformString: String) {
        print("Should parse string and set new matrix")
    }
    
    func translate(to point: CGPoint) {
    
    }
}
