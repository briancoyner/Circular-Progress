//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

public final class ProgressLayer: CAShapeLayer {

    /// Developers call this method to change the progress of the layer.
    /// The progress is clamped to a value between 0.0 and 1.0.
    ///
    /// Upon changing, the `angle` property is updated to reflect the current
    /// angle (in radians).
    public var progress: FractionCompleted = 0.0 {
        didSet {
            angle = CGFloat(progress.rawValue * (.pi * 2))
        }
    }

    /// - Note: The `NSManaged` is a Core Data annotation that tells the compiler
    /// the implementation is provided at runtime. In this case, Core Animation
    /// provides the implementation. Without this we can't animate the `angle`
    /// property (at least not in this way).
    ///
    /// - SeeAlso: `ProgressLayerDelegate`
    @NSManaged internal private(set) var angle: CGFloat
}
