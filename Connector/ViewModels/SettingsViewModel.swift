//
//  SettingsViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 28/11/2022.
//

import UIKit

class SettingsViewModel {
    private let userPreferencesServices: UserPreferencesServices
    private let authServices: AuthServicesProtocol
    
    init(userPreferencesServices: UserPreferencesServices, authServices: AuthServicesProtocol) {
        self.authServices = authServices
        self.userPreferencesServices = userPreferencesServices
    }
    
    func selectUserInterfaceStyle(_ selectedStyle: UIUserInterfaceStyle?) {
        guard let selectedStyle = selectedStyle else { return }
        userPreferencesServices.updateUserInterfaceStyle(with: selectedStyle)
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = selectedStyle
        }
        
    }
    
    func signOut() throws {
        try authServices.signOut()
    }
}
