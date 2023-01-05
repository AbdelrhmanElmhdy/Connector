//
//  SettingsViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

@objc protocol ObjcSettingsViewController {
	@objc func didToggleReceiveNotificationsSwitch(sender: UISwitch)
}

protocol SettingsViewController: ObjcSettingsViewController {
	func didPressLogout()
	func didSelectUserInterfaceStyle(_ style: UIUserInterfaceStyle?)
}
