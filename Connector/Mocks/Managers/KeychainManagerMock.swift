//
//  KeychainManagerMock.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

/// Replaces keychain persistence with in-memory persistence
class KeychainManagerMock: KeychainManagerProtocol {
	
	var currentUserId = ""
	var accessToken = ""
	
}
