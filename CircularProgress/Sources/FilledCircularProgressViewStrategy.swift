//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

/// A `CircularProgressViewStrategy` with the following characteristics.
///
/// Background Layer
/// - displays a thin circle.
/// - circular path color is based on the tint color.
/// - rotates with an open gap in the indeterminate state.
///
/// Progress Layer
/// - displays a pie "slice" that hugs the inside of the background circle.
/// - circular path fill color is based on the tint color.
/// - invisible in the indeterminate state.
///
/// Rounded Rect Layer (custom)
/// - no custom layers.
///
/// This strategy is commonly used when displaying a list or grid view of non-cancellable asynchronous resources.

public final class FilledCircularProgressViewStrategy: CircularProgressViewStrategy {

    fileprivate let additionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy?

    public init(additionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy? = nil) {
        self.additionalContentLayoutStrategy = additionalContentLayoutStrategy
    }
}

extension FilledCircularProgressViewStrategy {

    public func layoutLayers(_ layers: CircularProgressView.Layers, center: CGPoint, radius: CGFloat) {
        let path = UIBezierPath(arcCenter: center, radius: radius).cgPath

        layers.backgroundLayer.path = path
        layers.backgroundLayer.lineWidth = backgroundLayerLineWidth(basedOnRadius: radius)

        let adjustedRadius = progressLayerRadius(basedOn: radius)
        layers.progressLayer.path = UIBezierPath(arcCenter: center, radius: adjustedRadius).cgPath
        layers.progressLayer.lineWidth = 0

        additionalContentLayoutStrategy?.layoutAdditionalContent(in: layers.additionalContentLayer, center: center, radius: radius)
    }
}

extension FilledCircularProgressViewStrategy {

    public func transitionLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State, tintColor: UIColor) {
        updateTintColor(tintColor, on: layers, state: state)
        animateLayers(layers, to: state)
        additionalContentLayoutStrategy?.transitionAdditionalContent(to: state, tintColor: tintColor)
    }
}

extension FilledCircularProgressViewStrategy {

    public func updateTintColor(_ tintColor: UIColor, on layers: CircularProgressView.Layers, state: CircularProgressView.State) {
        layers.backgroundLayer.strokeColor = tintColor.cgColor
        layers.progressLayer.strokeColor = tintColor.cgColor
        layers.progressLayer.fillColor = tintColor.cgColor

        additionalContentLayoutStrategy?.updateTintColor(tintColor, state: state)

        switch state {
        case .progress(_):
            layers.backgroundLayer.fillColor = tintColor.withAlphaComponent(0.3).cgColor
        case .indeterminate:
            layers.backgroundLayer.fillColor = UIColor.clear.cgColor
        }
    }
}

extension FilledCircularProgressViewStrategy {

    public func progressPath(for center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPath {
        let path = CGMutablePath()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: progressLayerRadius(basedOn: radius),
            startAngle: 0.0,
            endAngle: angle,
            clockwise: false
        )
        path.closeSubpath()

        return path
    }
}

extension FilledCircularProgressViewStrategy {

    fileprivate func animateLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State) {
        switch state {
        case .indeterminate:
            layers.backgroundLayer.fillColor = nil
            layers.progressLayer.opacity = 0
            addIndeterminateAnimation(to: layers.backgroundLayer)
        case .progress(_):
            layers.progressLayer.opacity = 1
            removeIndeterminateAnimation(from: layers.backgroundLayer)
        }
    }

    private func addIndeterminateAnimation(to indeterminateLayer: CAShapeLayer) {
        indeterminateLayer.strokeEnd = 0.9

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: (2.0 * .pi) - (.pi / 2.0))
        animation.autoreverses = false
        animation.repeatCount = .greatestFiniteMagnitude
        animation.duration = 1.6 // arbitrary time that looks good.

        indeterminateLayer.add(animation, forKey: String(describing: FilledCircularProgressViewStrategy.self))
    }

    private func removeIndeterminateAnimation(from indeterminateLayer: CAShapeLayer) {
        guard let animation = indeterminateLayer.animation(forKey: String(describing: FilledCircularProgressViewStrategy.self)) as? CABasicAnimation else {
            return
        }

        guard animation.keyPath == "transform.rotation.z" else {
            return
        }

        indeterminateLayer.strokeEnd = 1.0
        indeterminateLayer.add(CABasicAnimation(), forKey: String(describing: FilledCircularProgressViewStrategy.self))
    }
}

extension FilledCircularProgressViewStrategy {

    fileprivate func backgroundLayerLineWidth(basedOnRadius radius: CGFloat) -> CGFloat {
        return floor(max(radius * 0.15, 4.0))
    }

    fileprivate func progressLayerRadius(basedOn radius: CGFloat) -> CGFloat {
        return radius - floor((backgroundLayerLineWidth(basedOnRadius: radius) / 2))
    }
}
