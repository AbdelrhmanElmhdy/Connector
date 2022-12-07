//
//  KeychainPropertyWrapper.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 30/11/2022.
//

import Foundation
import SwiftKeychainWrapper

@propertyWrapper
struct KeychainProperty <T: Codable> {
    
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: key) else {
                return defaultValue
            }
            
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            KeychainWrapper.standard.set(data, forKey: key)
        }
    }
}
