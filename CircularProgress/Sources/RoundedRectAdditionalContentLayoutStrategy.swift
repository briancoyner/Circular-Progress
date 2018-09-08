//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

/// An "additional" content layout strategy that displays a small rounded rect in the center
/// of the progress view.
///
/// The small rounded rect indicates that the user can cancel/ stop the workflow being
/// tracked by this progress view. It's important to note that the progress view doesn't
/// have any concept of cancelling. Therefore, the developer is responsible for attaching
/// an appropriate touch handler to the progress view when using this strategy.

public final class RoundedRectAdditionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy {

    fileprivate lazy var roundedRectLayer = self.lazyRoundedRectLayer()

    public init() {
    }
}

extension RoundedRectAdditionalContentLayoutStrategy {

    public func layoutAdditionalContent(in layer: CALayer, center: CGPoint, radius: CGFloat) {
        if roundedRectLayer.superlayer == nil {
            layer.addSublayer(roundedRectLayer)
        }

        let sideLength = radius * 0.4
        let rect = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)

        let cornerRadius = sideLength / 8
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        roundedRectLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.allCorners], cornerRadii: cornerRadii).cgPath
        roundedRectLayer.bounds = rect
        roundedRectLayer.position = center
    }
}

extension RoundedRectAdditionalContentLayoutStrategy {

    public func transitionAdditionalContent(to state: CircularProgressView.State, tintColor: UIColor) {
        updateTintColor(tintColor, state: state)
    }
}

extension RoundedRectAdditionalContentLayoutStrategy {

    public func updateTintColor(_ tintColor: UIColor, state: CircularProgressView.State) {
        roundedRectLayer.fillColor = tintColor.cgColor
    }
}

extension RoundedRectAdditionalContentLayoutStrategy {

    fileprivate func lazyRoundedRectLayer() -> CAShapeLayer {
        let roundedRectLayer = CAShapeLayer()
        roundedRectLayer.contentsScale = UIScreen.main.scale

        return roundedRectLayer
    }
}
