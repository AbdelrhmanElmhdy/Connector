//
//  SettingsViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

@objc protocol SettingsViewController {
    func didPressLogout()
    @objc func didToggleReceiveNotificationsSwitch(sender: UISwitch)
}
