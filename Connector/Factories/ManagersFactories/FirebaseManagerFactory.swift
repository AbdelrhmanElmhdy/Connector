//
//  FirebaseManagerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

class FirebaseManagerFactory {
    static func create() -> FirebaseManager {
        let environment = ProcessInfo.processInfo.environment["ENV"]
        return environment == "Test" ? RealFirebaseManager(fireStorePort: 8080, authPort: 9099) : RealFirebaseManager()
    }
}
