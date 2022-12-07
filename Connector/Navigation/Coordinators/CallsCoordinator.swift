//
//  CallsCoordinator.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/11/2022.
//

import UIKit

class CallsCoordinator: Coordinator {
    var children = Array<Coordinator>()
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllerFactory
    unowned var parentCoordinator: TabBarCoordinator
    
    init(navigationController: UINavigationController,
         viewControllerFactory: ViewControllerFactory,
         parentCoordinator: TabBarCoordinator) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewController = viewControllerFactory.createCallsTableViewController(for: self)
        navigationController.pushViewController(viewController, animated: false)
    }
}
