//
//  KeychainManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import Foundation
import SwiftKeychainWrapper

struct KeychainManager {
    struct KeychainKeys {
        static let accessToken = "accessToken"
    }
    
    static var accessToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: KeychainKeys.accessToken)
        } set {
            guard let newValue = newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: KeychainKeys.accessToken)
        }
    }
}
