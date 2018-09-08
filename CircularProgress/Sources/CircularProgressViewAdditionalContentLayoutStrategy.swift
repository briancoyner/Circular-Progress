//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

public protocol CircularProgressViewAdditionalContentLayoutStrategy {

    /// This method executes each time the `layoutSubviews()` method executes.
    ///
    /// Implementations must adjust any additional content sublayers based on the given
    /// center and radius.
    ///
    /// Implementations may add custom sublayers to the `additionalContentLayer`. For example,
    /// an implementation may add a text layer displaying the current progress as a string.
    ///
    /// - Parameters:
    ///   - layer: a non-visible layer to add sublayers to.
    ///   - center: the progress view's center/ position.
    ///   - radius: the current radius.
    func layoutAdditionalContent(in layer: CALayer, center: CGPoint, radius: CGFloat)

    /// This method executes when the view's state changes.
    ///
    /// - Parameters:
    ///   - state: the view's new state.
    ///   - tintColor: the current tint color (provided as a convenience in case it's needed).
    func transitionAdditionalContent(to state: CircularProgressView.State, tintColor: UIColor)

    /// This method executes when the view's tint color changes.
    ///
    /// - Parameters:
    ///   - tintColor: the new tint color.
    ///   - state: the current state of the progress view.
    func updateTintColor(_ tintColor: UIColor, state: CircularProgressView.State)
}
