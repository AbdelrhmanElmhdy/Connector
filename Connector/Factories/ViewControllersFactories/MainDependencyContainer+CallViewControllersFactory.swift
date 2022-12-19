//
//  MainDependencyContainer+CallViewControllersFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

extension MainDependencyContainer: CallViewControllersFactory {
    func createCallsTableViewController(for coordinator: Coordinator) -> CallsTableViewController {
        let viewController = CallsTableViewController(coordinator: coordinator)
        return viewController
    }
}
