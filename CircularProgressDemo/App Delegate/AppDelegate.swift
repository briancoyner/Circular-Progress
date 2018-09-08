//
//  Created by Brian Coyner on 8/8/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()
}

extension AppDelegate {

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        //
        // This app displays a simple "menu" of options for playing around with
        // circular progress view demos.
        //
        // See the `CircularProgressViewMenuBuilder` for additional details.
        //

        let menuViewController = MenuViewController(menuBuilder: CircularProgressViewMenuBuilder())
        let navigationController = UINavigationController(rootViewController: menuViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
