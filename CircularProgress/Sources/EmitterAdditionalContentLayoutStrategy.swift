//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

/// An "additional" content layout strategy that displays progress as localized text in the center
/// of the progress view.
///
/// Developers may override the text color if the view's tint color is not desired.

public final class EmitterAdditionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy {

    fileprivate lazy var emitterLayer = self.lazyEmitterLayer()
    fileprivate var center: CGPoint = CGPoint()
    fileprivate var radius: CGFloat = 0
}

extension EmitterAdditionalContentLayoutStrategy {

    public func layoutAdditionalContent(in layer: CALayer, center: CGPoint, radius: CGFloat) {
        if emitterLayer.superlayer == nil {
            layer.addSublayer(emitterLayer)
            emitterLayer.position = center
        }

        self.center = center
        self.radius = radius
    }
}

extension EmitterAdditionalContentLayoutStrategy {

    public func transitionAdditionalContent(to state: CircularProgressView.State, tintColor: UIColor) {
        guard case .progress(let percentComplete) = state else {
            return
        }


    }

    public func updateTintColor(_ tintColor: UIColor, state: CircularProgressView.State) {
        updateEmitterLayerTintColor(to: tintColor)
    }
}

extension EmitterAdditionalContentLayoutStrategy {

    fileprivate func lazyEmitterLayer() -> CAEmitterLayer {

        // Generates an interesting "sparkle" particle system.

        let emitterLayer = CAEmitterLayer()

        let spark = CAEmitterCell()
        spark.birthRate = 250

        spark.lifetime = 2
        spark.lifetimeRange = 2

        spark.speed = 5

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

        spark.contents = UIImage(named: "Spark")!.cgImage!

        spark.greenRange = 1
        spark.redRange = 0.75
        spark.blueRange = 0.5

        emitterLayer.emitterCells = [spark]


        return emitterLayer
    }

    fileprivate func updateEmitterLayerTintColor(to tintColor: UIColor) {
        emitterLayer.emitterCells?.forEach({
            $0.color = tintColor.cgColor
        })

        // It appears that CAEmitterLayer won't pick up the cell color change
        // unless we "reset" the layers. This hack seems to work.
        let original = emitterLayer.emitterCells
        emitterLayer.emitterCells = []
        emitterLayer.emitterCells = original
    }
}
