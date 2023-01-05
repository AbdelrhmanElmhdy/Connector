//
//  UserDefaultsManagerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

class UserDefaultsManagerFactory {
	static func make() -> UserDefaultsManagerProtocol {
		return ENV.context == .test ? UserDefaultsManagerMock() : UserDefaultsManager()
	}
}
