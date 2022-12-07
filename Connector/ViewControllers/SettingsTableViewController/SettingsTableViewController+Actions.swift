//
//  SettingsTableViewController+Actions.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import Foundation

extension SettingsViewController { // + Actions
    
    func didTabGeneral() {
        coordinator.customizeGeneralSettings()
    }
    
    func didTabAccount() {
        coordinator.customizeAccountSettings()
    }
    
    func didTabNotifications() {
        coordinator.customizeNotificationsSettings()
    }
    
    func didTabSoundAndHaptics() {
        coordinator.customizeSoundsAndHapticsSettings()
    }
    
    func didTabLogout() {
        do { try viewModel.signOut() }
        catch { ErrorManager.shared.presentSomethingWentWrongError(originalError: error, reportError: true); return; }
        
        coordinator.logout()
    }
    
}
