//
//  Created by Brian Coyner on 8/9/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

    convenience init(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        spacing: CGFloat = UIStackView.spacingUseSystem
    ) {
        self.init(arrangedSubviews: arrangedSubviews)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
