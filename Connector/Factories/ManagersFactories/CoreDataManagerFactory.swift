//
//  CoreDataManagerFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import CoreData

class CoreDataManagerFactory {
	static func make() -> CoreDataManagerProtocol {
		return ENV.context == .test
		? CoreDataManager(persistentContainerName: "Connector", storageType: NSInMemoryStoreType)
		: CoreDataManager(persistentContainerName: "Connector")
	}
}
