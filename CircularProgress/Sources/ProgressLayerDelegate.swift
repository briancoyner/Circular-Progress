//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

/// A layer delegate set specifically on an instance of a `ProgressLayer` to
/// create a `CABasicAnimation` when the layer's custom `angle` property
/// changes.

final class ProgressLayerDelegate: NSObject, CALayerDelegate {

    private weak var delegate: CAAnimationDelegate?

    init(delegate: CAAnimationDelegate) {
        self.delegate = delegate
    }
}

extension ProgressLayerDelegate {

    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == #keyPath(ProgressLayer.angle) {
            let animation = CABasicAnimation(keyPath: event)

            animation.duration = 0.4

            animation.fromValue = layer.presentation()?.value(forKey: event)
            animation.delegate = delegate

            return animation
        } else {
            return nil
        }
    }
}
