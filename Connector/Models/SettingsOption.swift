//
//  SettingsOption.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import Foundation
import UIKit

class SettingsSection {
    let title: String
    let options: [SettingsOption]
    
    init(title: String = "", options: [SettingsOption]) {
        self.title = title
        self.options = options
    }
}

enum SettingsOption {
    case disclosure(option: SettingsDisclosureOption)
    case `switch`(option: SettingsSwitchOption)
    case button(option: SettingsButtonOption)
    case value(option: SettingsValueOption)
}

// Note: The settings option types must be reference types (classes) so changes in their values can be propagated through all the settings view-controllers in the stack automatically.

class SettingsDisclosureOption {
    let icon: UIImage?
    let label: String
    let children: [SettingsSection]
    
    var selectedValue: SettingsValueOption? {
        for settingsOption in children.enumeratedOptions {
            if case .value(let option) = settingsOption, option.isSelected {
                return option
            }
        }
        
        return nil
    }
    
    init(icon: UIImage? = nil, label: String, children: [SettingsSection]) {
        self.icon = icon
        self.label = label
        self.children = children
    }
}

class SettingsSwitchOption {
    let icon: UIImage?
    let label: String
    let toggleHandler: Selector
    let `switch` = UISwitch(frame: .zero)
    
    /// - Note: toggleHandlerTarget is not retained.
    init(icon: UIImage? = nil,
         label: String,
         toggleHandler: Selector,
         toggleHandlerTarget: Any) {
        self.icon = icon
        self.label = label
        self.toggleHandler = toggleHandler
        
        `switch`.addTarget(toggleHandlerTarget, action: toggleHandler, for: .valueChanged)
    }
}

class SettingsButtonOption {
    enum Style {
        case normal, destructive
    }
    
    let icon: UIImage?
    let label: String
    let style: Style
    let tapHandler: () -> Void
    
    var labelColor: UIColor {
        switch style {
        case .normal:
            return .accent
        case .destructive:
            return .systemRed
        }
    }
    
    init(icon: UIImage? = nil, label: String, style: Style, tapHandler: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.style = style
        self.tapHandler = tapHandler
    }
}

class SettingsValueOption {
    let label: String
    let value: Int
    var isSelected: Bool
    let tapHandler: (_ value: Int) -> Void
    
    init(label: String, value: Int, isSelected: Bool = false, tapHandler: @escaping (_ value: Int) -> Void) {
        self.label = label
        self.value = value
        self.isSelected = isSelected
        self.tapHandler = tapHandler
    }
}

extension BidirectionalCollection where Element == SettingsSection {
    var enumeratedOptions: [SettingsOption] {
        var allOptions = Array<SettingsOption>()
        
        for section in self {
            allOptions += section.options
        }
        
        return allOptions
    }
    
    func updateSelectedValue(selectedValue: Int) {
        for option in self.enumeratedOptions {
            if case .value(let valueOption) = option {
                valueOption.isSelected = valueOption.value == selectedValue
            }
        }
    }
}
