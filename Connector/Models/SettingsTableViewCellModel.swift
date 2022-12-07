//
//  SettingsTableViewCellModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import Foundation
import UIKit

struct SettingsTableViewCellModel {
    let icon: UIImage?
    let label: String
    let tabHandler: () -> Void
}
