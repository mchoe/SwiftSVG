//
//  Created by Oliver Jones on 2/12/17.
//

import Foundation

public protocol Identifiable {}

extension Identifiable where Self : SVGShapeElement {
    var identityAttributes: [String : (String) -> ()] {
        return [
            "id": self.identify
        ]
    }

    /**
     Sets the identifier of the underlying `SVGLayer`.
     - SeeAlso: CALayer's [`name`](https://developer.apple.com/documentation/quartzcore/calayer/1410879-name) property
     */
    func identify(identifier: String) {
        self.svgLayer.name = identifier
    }
}
