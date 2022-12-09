//
//  SettingsTableViewController+Actions.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import UIKit

extension SettingsTableViewController: SettingsViewController { // + Actions
    
    @objc func didToggleReceiveNotificationsSwitch(sender: UISwitch) {
        print(sender.isOn)
    }
    
    func didSelectUserInterfaceStyle(_ style: UIUserInterfaceStyle?) {
        viewModel.selectUserInterfaceStyle(style)
    }
        
    func didPressLogout() {
        do { try viewModel.signOut() }
        catch { ErrorManager.shared.presentSomethingWentWrongError(originalError: error, reportError: true); return; }
        
        coordinator.logout()
    }
    
}
