//
//  Created by Brian Coyner on 4/28/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation

protocol MenuBuilder {

    /// The title of the view controller displaying the `[Menu]`.
    var title: String { get }

    func makeMenu() -> [Menu]
}
