//
//  CoreDataManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    enum contextType {
        case main, background
    }
        
    typealias ObjectIDsOfEntities = Dictionary<String, [NSManagedObjectID]>
    
    // MARK: Properties
    
    let persistentContainer: NSPersistentContainer
    let mainThreadContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    /// Returns the mainThread context or the backgroundContext depending on which thread you're accessing it from.
    /// - Note: Must be used with its perform or performAndWait methods to access the internal private queue of the background context.
    var context: NSManagedObjectContext {
        Thread.isMainThread ? mainThreadContext : backgroundContext
    }
    
    private var readyToMoveObjectIDsCache = ObjectIDsOfEntities()
    
    init(persistentContainerName: String) {
        let container = NSPersistentContainer(name: "Connector")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        self.persistentContainer = container
        self.mainThreadContext = container.viewContext
        self.backgroundContext = container.newBackgroundContext()
        
        self.mainThreadContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.mainThreadContext.undoManager = nil
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext.undoManager = nil
        
        
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
                                               object: self.backgroundContext,
                                               queue: .main,
                                               using: backgroundContextDidSave)
    }
    
    func backgroundContextDidSave(notification: Notification) {
        mainThreadContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        mainThreadContext.mergeChanges(fromContextDidSave: notification)
    }
    
    static func printSqliteFilePath() {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
    // MARK: CRUD Operations
            
    func createManagedObject<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withID id: String) -> ManagedObject? {
        guard ManagedObject.entity().attributesByName["id"] != nil else { return nil }
        
        var newObject: ManagedObject!
        
        context.performAndWait {
            newObject = ManagedObject(context: context)
            newObject.setValue(id, forKey: "id")
        }
        
        return newObject
    }
    
    func fetchManagedObjects<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [ManagedObject]? {
        var fetchedObjects: [ManagedObject]?
        
        context.performAndWait {
            fetchedObjects = try? context.fetch(fetchRequest) as? [ManagedObject]
        }
        
        return fetchedObjects
    }
    
    func fetchManagedObjects<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, predicate: NSPredicate, fetchLimit: Int = 0) -> [ManagedObject]? {
        let fetchRequest = type.fetchRequest()
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = fetchLimit
        
        return fetchManagedObjects(fetchRequest: fetchRequest)
    }
    
    func fetchManagedObject<ManagedObject: NSManagedObject>(withObjectID objectID: NSManagedObjectID) throws -> ManagedObject? {
        try context.existingObject(with: objectID) as? ManagedObject
    }
    
    func fetchManagedObjects<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withObjectIDs objectIDs: [NSManagedObjectID]) -> [ManagedObject]? {
        let predicate = NSPredicate(format: "self in %@", objectIDs)
        return fetchManagedObjects(ofType: type, predicate: predicate)
    }
    
    func fetchManagedObject<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withID id: String) -> ManagedObject? {
        guard ManagedObject.entity().attributesByName["id"] != nil else { return nil }
        
        let predicate = NSPredicate(format: "id == '\(id)'")
        
        return fetchManagedObjects(ofType: type, predicate: predicate, fetchLimit: 1)?.first
    }
    
    func deleteManagedObject(_ object: NSManagedObject) {
        context.performAndWait {
            context.delete(object)
        }
    }
        
    // MARK: Utilities
    
    func commitChanges(onContext contextType: contextType? = nil) throws {
        let moc: NSManagedObjectContext
        
        switch contextType {
        case .main: moc = mainThreadContext
        case .background: moc = backgroundContext
        case .none: moc = context
        }
        
        guard moc.hasChanges else { return }
        
        try moc.performAndWait {
            try moc.save()
        }
    }
    
    
    func createFetchController<ManagedObject: NSManagedObject>(
        fetchRequest: NSFetchRequest<ManagedObject>,
        sectionNameKeyPath: String? = nil,
        cacheName: String? = nil
    ) -> NSFetchedResultsController<ManagedObject> {
        
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: sectionNameKeyPath,
                                                         cacheName: cacheName)
        return fetchController
    }
    
    func createFetchController<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<ManagedObject>) -> NSFetchedResultsController<ManagedObject> {
        createFetchController(fetchRequest: fetchRequest, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    /// Prepare the objects to be moved from one thread to another through committing it's changes by the current context and returning its object IDs that can be used to instantiate them back from any other thread using a different context.
    /// - Parameter objects: The objects to be moved to a different thread.
    /// - Returns: An array containing the managed object IDs that can be used to instantiate the objects from any other thread.
    func prepareToMoveToDifferentThread(_ objects: [NSManagedObject]) throws -> [NSManagedObjectID] {
        // Commit changes to assign permanent object IDs to all the objects.
        try commitChanges()
        
        let objectIDs = objects.map { $0.objectID }
        
        return objectIDs
    }
    
    func dropEntity(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        } catch {
            ErrorManager.shared.reportError(error)
        }
    }
    
}
