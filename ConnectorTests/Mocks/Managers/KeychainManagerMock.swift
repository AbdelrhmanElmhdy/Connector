//
//  KeychainManagerMock.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation
@testable import Connector

/// Replaces keychain persistence with in-memory persistence
class KeychainManagerMock: KeychainManager {
    
    var currentUserId = ""
    var accessToken = ""
    
}
