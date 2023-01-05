//
//  SettingsCoordinator.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/11/2022.
//

import UIKit

class SettingsCoordinator: Coordinator, LoggingOut, DisclosingSettings {
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
		let viewController = viewControllerFactory.createSettingsTableViewController(for: self, settingsSections: nil)
		viewController.title = .ui.settings
		navigationController.pushViewController(viewController, animated: false)
	}
	
	func logout() {
		parentCoordinator.logout()
	}
	
	func disclose(_ settingsDisclosureOption: SettingsDisclosureOption) {
		let settingsSections = settingsDisclosureOption.children
		let viewController = viewControllerFactory.createSettingsTableViewController(for: self, settingsSections: settingsSections)
		viewController.title = settingsDisclosureOption.label
		viewController.hidesBottomBarWhenPushed = true
		
		navigationController.pushViewController(viewController, animated: true)
	}
	
}
