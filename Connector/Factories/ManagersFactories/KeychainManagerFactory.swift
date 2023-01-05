//
//  KeychainManagerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

class KeychainManagerFactory {
	static func make() -> KeychainManagerProtocol {
		return ENV.context == .test ? KeychainManagerMock() : KeychainManager()
	}
}
