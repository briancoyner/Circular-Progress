//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation

/// An "additional" content layout strategy that composites other "additional" content layout strategies.
/// The z-order is based on the order of the strategies in the array. For example, the last strategy
/// draws on top of the first layer.

public final class CompositeCircularProgressViewAdditionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy {

    fileprivate let strategies: [CircularProgressViewAdditionalContentLayoutStrategy]

    public init(strategies: [CircularProgressViewAdditionalContentLayoutStrategy]) {
        self.strategies = strategies
    }
}

extension CompositeCircularProgressViewAdditionalContentLayoutStrategy {

    public func layoutAdditionalContent(in layer: CALayer, center: CGPoint, radius: CGFloat) {
        strategies.forEach({ $0.layoutAdditionalContent(in: layer, center: center, radius: radius) })
    }

    public func transitionAdditionalContent(to state: CircularProgressView.State, tintColor: UIColor) {
        strategies.forEach({ $0.transitionAdditionalContent(to: state, tintColor: tintColor) })
    }

    public func updateTintColor(_ tintColor: UIColor, state: CircularProgressView.State) {
        strategies.forEach({ $0.updateTintColor(tintColor, state: state) })
    }
}
