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
/// - displays a path that straddles the background circle.
/// - path color is based on the tint color.
/// - invisible in the indeterminate state.
///
/// Custom Content
/// - no custom content
///
/// Emitter Layer
/// - particle generation is based on the current progress (more progress, more particles).

public final class FireworksCircularProgressViewStrategy: CircularProgressViewStrategy {

    fileprivate lazy var emitterLayer = self.lazyEmitterLayer()

    public init() {
    }
}

extension FireworksCircularProgressViewStrategy {

    public func layoutLayers(_ layers: CircularProgressView.Layers, center: CGPoint, radius: CGFloat) {
        layers.backgroundLayer.path = UIBezierPath(arcCenter: center, radius: radius).cgPath
        layers.backgroundLayer.lineWidth = backgroundLayerLineWidth(basedOn: radius)

        layers.progressLayer.path = progressPath(for: center, radius: radius, angle: 0)
        layers.progressLayer.lineWidth = progressLayerLineWidth(basedOn: radius)

        layers.progressLayer.addSublayer(emitterLayer)
        emitterLayer.position = center
    }
}

extension FireworksCircularProgressViewStrategy {

    public func transitionLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State, tintColor _: UIColor) {
        animateLayers(layers, to: state)
    }
}

extension FireworksCircularProgressViewStrategy {

    public func updateTintColor(_ tintColor: UIColor, on layers: CircularProgressView.Layers, state: CircularProgressView.State) {
        layers.backgroundLayer.fillColor = UIColor.clear.cgColor
        layers.backgroundLayer.strokeColor = tintColor.cgColor

        layers.progressLayer.fillColor = UIColor.clear.cgColor
        layers.progressLayer.strokeColor = tintColor.triad.1.cgColor

        updateEmitterLayerTintColor(to: tintColor)
    }
}

extension FireworksCircularProgressViewStrategy {

    public func progressPath(for center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPath {

        adjustEmitterLayerPosition(for: center, radius: radius, angle: angle)

        return UIBezierPath(
            arcCenter: center,
            radius: progressLayerRadius(basedOn: radius),
            startAngle: 0.0,
            endAngle: angle,
            clockwise: true
        ).cgPath
    }

    private func adjustEmitterLayerPosition(for center: CGPoint, radius: CGFloat, angle: CGFloat) {
        emitterLayer.position = CGPoint(
            x: center.x + (radius * cos(angle)),
            y: center.y + (radius * sin(angle))
        )

        let fractionCompleted = angle / (2 * .pi)
        updateEmitterCell {
            $0.emissionRange = angle
            $0.velocity = fractionCompleted * 250
            $0.birthRate = Float(fractionCompleted * 200)
        }
    }
}

extension FireworksCircularProgressViewStrategy {

    private func animateLayers(_ layers: CircularProgressView.Layers, to state: CircularProgressView.State) {
        switch state {
        case .indeterminate:

            addIndeterminateAnimation(to: layers.backgroundLayer)
            layers.progressLayer.opacity = 0.0
        case .progress(_):
            layers.progressLayer.opacity = 1.0
            removeIndeterminateAnimation(from: layers.backgroundLayer)
        }
    }

    private func addIndeterminateAnimation(to indeterminateLayer: CAShapeLayer) {
        indeterminateLayer.strokeStart = 0.0
        indeterminateLayer.strokeEnd = 0.9

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: (2.0 * .pi) - (.pi / 2.0))
        animation.autoreverses = false
        animation.repeatCount = .greatestFiniteMagnitude
        animation.duration = 1.6

        indeterminateLayer.add(animation, forKey: String(describing: FireworksCircularProgressViewStrategy.self))
    }

    private func removeIndeterminateAnimation(from indeterminateLayer: CAShapeLayer) {
        guard let animation = indeterminateLayer.animation(forKey: String(describing: FireworksCircularProgressViewStrategy.self)) as? CABasicAnimation else {
            return
        }

        guard animation.keyPath == "transform.rotation.z" else {
            return
        }

        indeterminateLayer.strokeStart = 0.0
        indeterminateLayer.strokeEnd = 1.0

        indeterminateLayer.removeAnimation(forKey: String(describing: FireworksCircularProgressViewStrategy.self))

        indeterminateLayer.add(CABasicAnimation(), forKey: String(describing: InsetCircularProgressViewStrategy.self))
    }
}

extension FireworksCircularProgressViewStrategy {

    private func backgroundLayerLineWidth(basedOn radius: CGFloat) -> CGFloat {
        return floor(max(radius * 0.075, 2.0))
    }

    private func progressLayerLineWidth(basedOn radius: CGFloat) -> CGFloat {
        return floor(max(radius * 0.15, 2.0))
    }

    private func progressLayerRadius(basedOn radius: CGFloat) -> CGFloat {
        return radius
    }
}

extension FireworksCircularProgressViewStrategy {

    fileprivate func lazyEmitterLayer() -> CAEmitterLayer {

        // Generates an interesting "sparkle" particle system.
        
        let emitterLayer = CAEmitterLayer()

        let spark = CAEmitterCell()
        spark.contents = UIImage(named: "Spark")!.cgImage!
        spark.speed = 5

        spark.lifetime = 2
        spark.lifetimeRange = 2

        spark.alphaRange = 1
        spark.alphaSpeed = 1

        spark.emissionRange = 0
        spark.emissionRange = .pi * 2
        spark.velocity = 200
        spark.velocityRange = 50

        spark.xAcceleration = 0
        spark.yAcceleration = 0
        spark.zAcceleration = 0

        spark.scale = 0.235
        spark.scaleRange = 0.4
        spark.scaleSpeed = -0.5

        spark.greenRange = 1
        spark.redRange = 0.75
        spark.blueRange = 0.5

        emitterLayer.emitterCells = [spark]

        return emitterLayer
    }

    fileprivate func updateEmitterLayerTintColor(to tintColor: UIColor) {
        updateEmitterCell {
            $0.color = tintColor.cgColor
        }
    }

    fileprivate func updateEmitterCell(_ body: (CAEmitterCell) -> Void) {
        // It appears that CAEmitterLayer won't pick up the cell color change
        // unless we "reset" the layers. This hack seems to work.
        guard let emitterCell = emitterLayer.emitterCells?.first else {
            return
        }

        body(emitterCell)

        emitterLayer.emitterCells = []
        emitterLayer.emitterCells = [emitterCell]
    }
}
