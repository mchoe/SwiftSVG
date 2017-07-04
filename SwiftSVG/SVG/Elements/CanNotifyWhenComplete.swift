//
//  CanNotifyWhenComplete.swift
//  SwiftSVG
//
//  Created by tarragon on 7/4/17.
//  Copyright © 2017 Strauss LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


protocol CanManageAsychronousCallbacks {
    func finishedProcessing(_ boundingBox: CGRect?)
}

protocol ParsesAsynchronously {
    var asyncParseManager: CanManageAsychronousCallbacks? { get set }
}
