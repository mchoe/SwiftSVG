//
//  DispatchQueue+Extensions.swift
//  SwiftSVG
//
//  Created by tarragon on 7/1/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

import Foundation


extension DispatchQueue {
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
