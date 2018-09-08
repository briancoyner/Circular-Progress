//
//  Created by Brian Coyner on 4/28/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation

struct Menu {
    let title: String?
    let items: [MenuItem]

    init(title: String? = nil, items: [MenuItem]) {
        self.title = title
        self.items = items
    }
}
