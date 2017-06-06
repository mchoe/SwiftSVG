//
//  String+Trim.swift
//  SwiftSVG
//
//  Created by Michael Choe on 6/5/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation

extension String {
    
    func trimWhitespace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
}
