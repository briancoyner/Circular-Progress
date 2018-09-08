//
//  Created by Brian Coyner on 11/15/15.
//  Copyright © 2015-2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    public var compliment: UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        hue = hue - 0.5
        if hue < 0 {
            hue += 1.0
        }

        if saturation < 0.5 {
            saturation = 0.75
        }

        if brightness < 0.5 {
            brightness = 0.75
        }

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

extension UIColor {

    public var triad: (UIColor, UIColor) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        if saturation < 0.5 {
            saturation = 1.0
        }

        if brightness < 0.5 {
            brightness = 1.0
        }

        return (
            UIColor(hue: adjust(hue, delta: 0.5 + 0.0813), saturation: saturation, brightness: brightness, alpha: 1.0),
            UIColor(hue: adjust(hue, delta: 0.5 - 0.0813), saturation: saturation, brightness: brightness, alpha: 1.0)
        )
    }

    private func adjust(_ hue: CGFloat, delta: CGFloat) -> CGFloat {
        var adjustedHue = hue - delta
        if adjustedHue < 0 {
            adjustedHue += 1.0
        }

        return adjustedHue
    }
}
