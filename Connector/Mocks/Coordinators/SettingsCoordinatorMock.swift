//
//  SettingsCoordinatorMock.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/12/2022.
//

import UIKit

class SettingsCoordinatorMock: Coordinator, LoggingOut, DisclosingSettings {
	var children = Array<Coordinator>()
	let navigationController = UINavigationController()
	
	func start() {
		
	}
	
	func logout() {
		
	}
	
	func disclose(_ settingsDisclosureOption: SettingsDisclosureOption) {
		
	}
	
}
