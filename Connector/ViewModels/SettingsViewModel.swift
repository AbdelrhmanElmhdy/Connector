//
//  SettingsViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 28/11/2022.
//

import Foundation

class SettingsViewModel {
    private let authServices: AuthServicesProtocol
    
    init(authServices: AuthServicesProtocol) {
        self.authServices = authServices
    }
    
    func signOut() throws {
        try authServices.signOut()
    }
}
