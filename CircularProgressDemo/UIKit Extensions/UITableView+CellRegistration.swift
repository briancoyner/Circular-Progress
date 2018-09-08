//
//  Created by Brian Coyner on 5/1/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    public func registerReusableView(associatedWith reuseIdentifier: ReusableViewIdentifier) {
        switch reuseIdentifier {
        case .class(let type):
            register(type, forCellReuseIdentifier: type.reuseIdentifier)
        case .nib(let type, let bundle):
            let nib = UINib(nibName: type.reuseIdentifier, bundle: bundle)
            register(nib, forCellReuseIdentifier: type.reuseIdentifier)
        }
    }
}

extension UITableView {

    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
