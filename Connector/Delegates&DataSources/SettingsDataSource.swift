//
//  SettingsDataSource.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {
    let settingsSections: [SettingsSection]
    
    init(settingsSections: [SettingsSection]) {
        self.settingsSections = settingsSections
    }
    
    func getSettingsOption(forIndexPath indexPath: IndexPath) -> SettingsOption {
        let option = settingsSections[indexPath.section].options[indexPath.row]
        return option
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellReuseIdentifier, for: indexPath)
        let settingsOption = getSettingsOption(forIndexPath: indexPath)
        var contentConfiguration = UIListContentConfiguration.cell()
        
        switch settingsOption {
        case let .disclosure(option):
            contentConfiguration.text = option.label
            contentConfiguration.image = option.icon
            cell.accessoryType = .disclosureIndicator
            
        case let .switch(option):
            contentConfiguration.text = option.label
            contentConfiguration.image = option.icon
            cell.accessoryView = option.`switch`
            
        case let .button(option):
            contentConfiguration.text = option.label
            contentConfiguration.textProperties.alignment = .center
            contentConfiguration.textProperties.color = option.labelColor
            
        case .option:
            return UITableViewCell()
        }
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
}
