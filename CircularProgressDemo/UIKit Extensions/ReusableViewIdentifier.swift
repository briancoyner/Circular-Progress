//
//  Created by Brian Coyner on 4/28/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

public enum ReusableViewIdentifier {
    case `class`(ReuseIdentifierProvider.Type)
    case nib(ReuseIdentifierProvider.Type, bundle: Bundle)
}

extension ReusableViewIdentifier {

    public var reuseIdentifier: String {
        switch self {
        case .class(let identifier):
            return identifier.reuseIdentifier
        case .nib(let identifier, bundle:_):
            return identifier.reuseIdentifier
        }
    }
}

extension ReusableViewIdentifier: Hashable {

    public var hashValue: Int {
        return reuseIdentifier.hashValue
    }

    public static func ==(lhs: ReusableViewIdentifier, rhs: ReusableViewIdentifier) -> Bool {
        switch (lhs, rhs) {
        case (.class(let lhsType), .class(let rhsType)):
            return lhsType.reuseIdentifier == rhsType.reuseIdentifier
        case (.nib(let lhsType, _), .nib(let rhsType, _)):
            return lhsType.reuseIdentifier == rhsType.reuseIdentifier
        case (.class, _), (.nib, _):
            return false
        }
    }
}
