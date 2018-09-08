//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

public protocol CircularProgressViewStrategy {

    /// This method executes each time the `layoutSubviews()` method executes.
    ///
    /// Implementations must not adjust the layer's bounds or position. Doing so will most
    /// certainly cause layout issues.
    ///
    /// Implementations are free to modify the layer's "style" (e.g. `lineWidth`) based on the
    /// given `radius` value.
    ///
    /// Implementations may add custom sublayers to the `additionalContentLayer`. For example,
    /// an implementation may add a text layer displaying the current progress as a string.
    ///
    /// - Parameters:
    ///   - layers: a collection of layers that can be adjusted per the requirements of the strategy.
    ///   - center: the progress view's center/ position relative to the view.
    ///   - radius: the current radius.
    func layoutLayers(_ layers: CircularProgressView.Layers, center: CGPoint, radius: CGFloat)

    /// This method executes when the view's `State` changes.
    ///
    /// - Parameters:
    ///   - layers: a collection of layers that can be adjusted per the requirements of the strategy.
    ///   - state: the view's new state.
    ///   - tintColor: the current tint color (provided as a convenience in case it's needed).
    func transitionLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State, tintColor: UIColor)

    /// This method executes when the view's tint color changes.
    ///
    /// - Parameters:
    ///   - tintColor: the new tint color.
    ///   - layers: a collection of layers whose colors can be adjusted per the requirements of the strategy.
    ///   - state: the current state of the progress view.
    func updateTintColor(_ tintColor: UIColor, on layers: CircularProgressView.Layers, state: CircularProgressView.State)

    /// This method executes when the `ProgressView`'s `angle` property changes. Implementations
    /// must return a path that represents the current progress.
    ///
    /// - Parameters:
    ///   - center: the progress view's center/ position relative to the view.
    ///   - radius: the current radius.
    ///   - angle: the current angle (radians).
    /// - Returns: a new `CGPath` representing the current progress.
    func progressPath(for center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPath
}
