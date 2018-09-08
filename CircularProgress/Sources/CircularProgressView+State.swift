//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

extension CircularProgressView {

    public enum State {
        case indeterminate
        case progress(FractionCompleted)
    }
}
