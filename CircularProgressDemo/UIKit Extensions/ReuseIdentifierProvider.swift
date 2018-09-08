//
//  Created by Brian Coyner on 4/28/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

public protocol ReuseIdentifierProvider: AnyObject {

    static var reuseIdentifier: String { get }
}

extension ReuseIdentifierProvider where Self: UIView {

    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
