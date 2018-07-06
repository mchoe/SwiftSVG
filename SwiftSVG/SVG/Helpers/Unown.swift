//
//  Unown.swift
//  SwiftSVG
//
//  Created by Quentin Fasquel on 06/07/2018.
//  Copyright © 2018 Strauss LLC. All rights reserved.
//

import Foundation

public func unown<T: AnyObject, U, V>(_ owner: T, _ method: @escaping (T) -> ((U) -> V)) -> (U) -> V {
  return { [unowned owner] arg in method(owner)(arg) }
}
