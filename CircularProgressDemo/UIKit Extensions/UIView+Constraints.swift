//
//  Created by Brian Coyner on 1/24/16.
//  Copyright © 2016 Brian Coyner. All rights reserved.
//

import UIKit

extension UIView {

    func constrain(toView view: UIView) {
        NSLayoutConstraint.activate(constraints(forConstrainingTo: view))
    }

    func constraints(forConstrainingTo view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }

    func constraints(forConstrainingTo layoutGuide: UILayoutGuide) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ]
    }
}
