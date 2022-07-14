//
//  UserDefaultsManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation
import UIKit

struct UserDefaultsManager {
    struct Keys {
        static let isLoggedIn = "IS_LOGGED_IN"
        static let user = "USER"
    }
    
    static var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isLoggedIn)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var user: User? {
        get {
            guard let userData = UserDefaults.standard.data(forKey: Keys.user) else { return nil }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: userData)
                return user
            } catch {
                ErrorManager.reportError(NetworkError.decodingFailed)
                return nil
            }
        }
        
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.set(nil, forKey: Keys.user)
                UserDefaults.standard.synchronize()
                return
            }
            
            do {
                let userData = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(userData, forKey: Keys.user)
                UserDefaults.standard.synchronize()
            } catch {
                ErrorManager.reportError(NetworkError.encodingFailed)
            }
        }
    }
    
}
