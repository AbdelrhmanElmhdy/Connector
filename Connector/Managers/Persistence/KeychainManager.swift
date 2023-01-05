//
//  KeychainManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 30/11/2022.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager: KeychainManagerProtocol {
	struct Keys {
		static let currentUserId = "CURRENT_USER_ID"
		static let accessToken = "ACCESS_TOKEN"
	}
	
	@SecureStorage(key: Keys.currentUserId, defaultValue: "")
	var currentUserId: String
	
	@SecureStorage(key: Keys.currentUserId, defaultValue: "")
	var accessToken: String
	
}
