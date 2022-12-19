
//
//  MainDependencyContainer+SettingsViewControllersFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

extension MainDependencyContainer: SettingsViewControllersFactory {
    func createSettingsTableViewController(for coordinator: SettingsCoordinator, settingsSections: [SettingsSection]? = nil) -> SettingsTableViewController {
        
        let viewModel = SettingsViewModel(userPreferencesService: userPreferencesService, authService: authService)
        let viewController = SettingsTableViewController(coordinator: coordinator, viewModel: viewModel)
        
        let settingsSections = settingsSections ?? settingsSectionFactory.createRootSettingsSections(forViewController: viewController)
        
        let dataSource = SettingsDataSource(settingsSections: settingsSections)
        viewController.datasource = dataSource
        
        return viewController
    }
    
}
