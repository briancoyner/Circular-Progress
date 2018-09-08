//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation

extension UIBezierPath {

    convenience public init(arcCenter: CGPoint, radius: CGFloat) {
        self.init(arcCenter: arcCenter, radius: radius, startAngle: 0.0, endAngle: .pi * 2, clockwise: true)
    }
}
