//
//  SettingsOption.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import Foundation
import UIKit

struct SettingsSection {
    var title: String = ""
    let options: [SettingsOption]
}

enum SettingsOption {
    case disclosure(option: SettingsDisclosureOption)
    case `switch`(option: SettingsSwitchOption)
    case button(option: SettingsButtonOption)
    case option
}

struct SettingsDisclosureOption {
    let icon: UIImage?
    let label: String
    let children: [SettingsSection]
    
    init(icon: UIImage?,
         label: String,
         children: [SettingsSection]) {
        self.icon = icon
        self.label = label
        self.children = children
    }
}

struct SettingsSwitchOption {
    let icon: UIImage?
    let label: String
    let toggleHandler: Selector
    let `switch` = UISwitch(frame: .zero)
    
    init(icon: UIImage?,
         label: String,
         toggleHandler: Selector,
         toggleHandlerTarget: Any) {
        self.icon = icon
        self.label = label
        self.toggleHandler = toggleHandler
        
        `switch`.addTarget(toggleHandlerTarget, action: toggleHandler, for: .valueChanged)
    }
}

struct SettingsButtonOption {
    enum Style {
        case normal, destructive
    }
    
    let label: String
    let style: Style
    let tabHandler: () -> Void
    
    var labelColor: UIColor {
        switch style {
        case .normal:
            return .accent
        case .destructive:
            return .systemRed
        }
    }
    
    init(label: String,
         style: Style,
         tabHandler: @escaping () -> Void) {
        self.label = label
        self.style = style
        self.tabHandler = tabHandler
    }
}
