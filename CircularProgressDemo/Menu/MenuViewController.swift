//
//  Created by Brian Coyner on 4/28/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

final class MenuViewController: UITableViewController {

    fileprivate let menus: [Menu]

    init(menuBuilder: MenuBuilder) {
        self.menus = menuBuilder.makeMenu()

        super.init(style: .grouped)

        self.title = menuBuilder.title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure(tableView)
    }
}

extension MenuViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menus[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        let menuItem = menus[indexPath.section].items[indexPath.row]

        cell.textLabel?.text = menuItem.title
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension MenuViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menus[indexPath.section].items[indexPath.row]

        let viewController = menuItem.viewControllerProvider()
        viewController.title = menuItem.title

        show(viewController, sender: self)
    }
}

extension MenuViewController {

    fileprivate func configure(_ tableView: UITableView) {
        tableView.registerReusableView(associatedWith: .class(MenuTableViewCell.self))
    }
}
