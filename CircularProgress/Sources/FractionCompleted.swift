//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation

/// A simple wrapper around a `Double` representing a value between 0.0 and 1.0.
/// The `FractionCompleted` name mimics the `Progress.fractionCompleted` property.

public struct FractionCompleted: ExpressibleByFloatLiteral {

    /// The value is in the of 0.0...1.0.
    public let rawValue: Double

    /// ```
    /// let fractionCompleted = FractionCompleted(0.3)
    /// ```
    ///
    /// - Parameter value: any `Double` value (adjusted to fit between 0.0...1.0).
    public init(_ value: Double) {
        self.init(floatLiteral: value)
    }

    /// ```
    /// let fractionCompleted: FractionCompleted = 0.3
    /// ```
    ///
    /// - Parameter value: a literal `Double` value (adjusted to fit between 0.0...1.0).
    public init(floatLiteral value: Double) {
        self.rawValue = max(0.0, min(value, 1.0))
    }
}
