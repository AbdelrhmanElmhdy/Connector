//
//  SettingsCoordinator.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/11/2022.
//

import UIKit

class SettingsCoordinator: Coordinator, LoggingOut, CustomizingGeneralSettings, CustomizingAccountSettings, CustomizingNotificationsSettings, CustomizingSoundsAndHapticsSettings {
    var children = Array<Coordinator>()
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllerFactory
    unowned var parentCoordinator: TabBarCoordinator
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllerFactory,
         parentCoordinator: TabBarCoordinator) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewController = viewControllerFactory.createSettingsViewController(for: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func logout() {
        parentCoordinator.logout()
    }
    
    func customizeGeneralSettings() {
        let viewController = viewControllerFactory.createSettingsCustomizationTableViewController(for: self)
        viewController.title = "General".localized
        viewController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func customizeAccountSettings() {
        let viewController = viewControllerFactory.createSettingsCustomizationTableViewController(for: self)
        viewController.title = "Account".localized
        viewController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func customizeNotificationsSettings() {
        let viewController = viewControllerFactory.createSettingsCustomizationTableViewController(for: self)
        viewController.title = "Notifications".localized
        viewController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func customizeSoundsAndHapticsSettings() {
        let viewController = viewControllerFactory.createSettingsCustomizationTableViewController(for: self)
        viewController.title = "Sounds & Haptics".localized
        viewController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
