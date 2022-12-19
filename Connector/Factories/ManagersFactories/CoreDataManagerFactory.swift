//
//  CoreDataManagerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import CoreData

class CoreDataManagerFactory {
    static func create() -> CoreDataManager {
        let environment = ProcessInfo.processInfo.environment["ENV"]
        
        return environment == "Test"
            ? RealCoreDataManager(persistentContainerName: "Connector", storageType: NSInMemoryStoreType)
            : RealCoreDataManager(persistentContainerName: "Connector")
    }
}
