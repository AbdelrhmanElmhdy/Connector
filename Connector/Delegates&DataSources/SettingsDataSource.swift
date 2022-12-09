//
//  SettingsDataSource.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {
    // MARK: Properties
    
    var settingsSections: [SettingsSection]
    
    // MARK: Initialization
        
    init(settingsSections: [SettingsSection]) {
        self.settingsSections = settingsSections
    }
    
    // MARK: DataSource
    
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
        var cell = tableView.dequeueReusableCell(withIdentifier: settingsCellReuseIdentifier, for: indexPath)
        let settingsOption = getSettingsOption(forIndexPath: indexPath)
        
        prepareCellForReuse(&cell)
        
        switch settingsOption {
        case let .disclosure(option):
            configureSettingsDisclosureOptionCell(&cell, disclosureOption: option)
        case let .switch(option):
            configureSettingsSwitchOptionCell(&cell, switchOption: option)
        case let .button(option):
            configureSettingsButtonOptionCell(&cell, buttonOption: option)
        case let .value(option):
            configureSettingsValueOptionCell(&cell, valueOption: option)
        }
        
        return cell
    }
    
    // MARK: Convenience
    
    func getSettingsOption(forIndexPath indexPath: IndexPath) -> SettingsOption {
        let option = settingsSections[indexPath.section].options[indexPath.row]
        return option
    }
    
    func updateSelectedValue(_ value: Int, forTableView tableView: UITableView) {
        settingsSections.updateSelectedValue(selectedValue: value)
        tableView.reloadData()
    }
    
    private func prepareCellForReuse(_ cell: inout UITableViewCell) {
        cell.contentConfiguration = nil
        cell.accessoryView = nil
        cell.accessoryType = .none
    }
    
    private func configureSettingsDisclosureOptionCell(_ cell: inout UITableViewCell, disclosureOption: SettingsDisclosureOption) {
        var contentConfiguration = UIListContentConfiguration.valueCell()
        contentConfiguration.text = disclosureOption.label
        contentConfiguration.image = disclosureOption.icon
        contentConfiguration.secondaryText = disclosureOption.selectedValue?.label
        
        cell.contentConfiguration = contentConfiguration
        cell.accessoryType = .disclosureIndicator
    }
    
    private func configureSettingsSwitchOptionCell(_ cell: inout UITableViewCell, switchOption: SettingsSwitchOption) {
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = switchOption.label
        contentConfiguration.image = switchOption.icon
        
        
        cell.contentConfiguration = contentConfiguration
        cell.accessoryView = switchOption.`switch`
        cell.selectionStyle = .none
    }
    
    private func configureSettingsButtonOptionCell(_ cell: inout UITableViewCell, buttonOption: SettingsButtonOption) {
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = buttonOption.label
        
        if let icon = buttonOption.icon {
            contentConfiguration.image = icon
            cell.accessoryType = .disclosureIndicator
        } else {
            contentConfiguration.textProperties.alignment = .center
        }
        
        contentConfiguration.textProperties.color = buttonOption.labelColor
        
        cell.contentConfiguration = contentConfiguration
    }
    
    private func configureSettingsValueOptionCell(_ cell: inout UITableViewCell, valueOption: SettingsValueOption) {
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = valueOption.label
        
        cell.contentConfiguration = contentConfiguration
        cell.accessoryType = valueOption.isSelected ? .checkmark : .none
    }
    
}
