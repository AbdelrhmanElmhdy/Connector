//
//  FirebaseManagerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

class FirebaseManagerFactory {
	static func make() -> FirebaseManagerProtocol {
		return ENV.context == .test ? FirebaseManager(fireStorePort: 8080, authPort: 9099) : FirebaseManager()
	}
}
