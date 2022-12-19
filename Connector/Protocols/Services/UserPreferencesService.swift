//
//  UserPreferencesService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

protocol UserPreferencesService: AutoMockable {
    func updateUserInterfaceStyle(with state: UIUserInterfaceStyle)
    func saveChanges()
}
