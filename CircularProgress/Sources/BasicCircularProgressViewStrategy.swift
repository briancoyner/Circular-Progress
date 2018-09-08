//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

/// A `CircularProgressViewStrategy` with the following characteristics.
///
/// Background Layer
/// - displays a thin black circle (ignores the tint color).
/// - "pulses" the black circle in the indeterminate state.
///
/// Progress Layer
/// - displays a path that straddles the background circle.
/// - path color is based on the tint color.
/// - visible in the indeterminate state (slightly transparent).
///
/// Custom Content
/// - this strategy requires a `CircularProgressViewAdditionalContentLayoutStrategy` implementation.
/// - most usages will use the `ProgressAsTextAdditionalContentLayoutStrategy` to display the percent complete.
/// - visible in all states.
///
/// This strategy may be used when displaying a "large" progress view as part of an app launch onboarding step.

public final class BasicCircularProgressViewStrategy: CircularProgressViewStrategy {

    fileprivate let additionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy

    public init(additionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy = LocalizedProgressAdditionalContentLayoutStrategy(textColor: .black)) {
        self.additionalContentLayoutStrategy = additionalContentLayoutStrategy
    }
}

extension BasicCircularProgressViewStrategy {

    public func layoutLayers(_ layers: CircularProgressView.Layers, center: CGPoint, radius: CGFloat) {
        let path = UIBezierPath(arcCenter: center, radius: radius).cgPath

        layers.backgroundLayer.path = path
        layers.progressLayer.path = path
        layers.progressLayer.lineWidth = max(radius * 0.125, 4.0)

        additionalContentLayoutStrategy.layoutAdditionalContent(in: layers.additionalContentLayer, center: center, radius: radius)
    }
}

extension BasicCircularProgressViewStrategy {

    public func transitionLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State, tintColor: UIColor) {
        animateLayers(layers, to: state)
        additionalContentLayoutStrategy.transitionAdditionalContent(to: state, tintColor: tintColor)
    }
}

extension BasicCircularProgressViewStrategy {

    public func updateTintColor(_ tintColor: UIColor, on layers: CircularProgressView.Layers, state: CircularProgressView.State) {
        layers.backgroundLayer.fillColor = UIColor.clear.cgColor
        layers.backgroundLayer.strokeColor = UIColor.black.cgColor

        layers.progressLayer.fillColor = UIColor.clear.cgColor
        layers.progressLayer.strokeColor = tintColor.cgColor

        additionalContentLayoutStrategy.updateTintColor(tintColor, state: state)

        switch state {
        case .indeterminate:
            layers.progressLayer.opacity = indeterminateProgressLayerOpacity
        case .progress(_):
            layers.progressLayer.opacity = defaultProgressLayerOpactity
        }
    }
}

extension BasicCircularProgressViewStrategy {

    public func progressPath(for center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPath {
        return UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0.0,
            endAngle: angle,
            clockwise: true
        ).cgPath
    }
}

extension BasicCircularProgressViewStrategy {

    fileprivate func animateLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State) {
        removeIndeterminateAnimation(from: layers.backgroundLayer)

        switch state {
        case .indeterminate:
            addIndeterminateAnimation(to: layers.backgroundLayer)
            layers.progressLayer.opacity = indeterminateProgressLayerOpacity
        case .progress(_):
            layers.progressLayer.opacity = defaultProgressLayerOpactity
        }
    }

    fileprivate func addIndeterminateAnimation(to backgroundLayer: CAShapeLayer) {
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
        pulseAnimation.toValue = backgroundLayer.lineWidth * 4.0
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        pulseAnimation.autoreverses = true
        pulseAnimation.duration = 1.0

        backgroundLayer.add(pulseAnimation, forKey: #keyPath(CAShapeLayer.lineWidth))
    }

    fileprivate func removeIndeterminateAnimation(from backgroundLayer: CAShapeLayer) {
        guard backgroundLayer.animation(forKey: #keyPath(CAShapeLayer.lineWidth)) != nil else {
            return
        }

        // Animate the line back to its default line width. This allows for a seamless
        // transition, which looks nice to the user.
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
        pulseAnimation.fromValue = backgroundLayer.presentation()?.lineWidth
        pulseAnimation.toValue = backgroundLayer.lineWidth
        pulseAnimation.duration = 1.0

        backgroundLayer.add(pulseAnimation, forKey: #keyPath(CAShapeLayer.lineWidth))
    }
}

extension BasicCircularProgressViewStrategy {

    fileprivate var indeterminateProgressLayerOpacity: Float {
        return 0.3
    }

    fileprivate var defaultProgressLayerOpactity: Float {
        return 1.0
    }
}
