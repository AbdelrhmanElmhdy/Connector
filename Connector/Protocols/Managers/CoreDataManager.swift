//
//  CoreDataManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 18/12/2022.
//

import Foundation
import CoreData

enum ContextType {
    case main, background, auto
}

/// An object that encapsulates the core data stack, manages all the crud operations, and acts as an `NSFetchController` factory.
protocol CoreDataManager: AnyObject, AutoMockable {
    var persistentContainer: NSPersistentContainer { get }
    var mainThreadContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    
    /// Returns the mainThread context or the backgroundContext depending on which thread you're accessing it from.
    /// - Note: Must be used with its perform or performAndWait methods to access the internal private queue of the background context.
    var context: NSManagedObjectContext { get }
    
    static func printSqliteFilePath()
    
    func createManagedObject<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withID id: String) -> ManagedObject?
    
    func fetchManagedObjects<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [ManagedObject]?
    
    func fetchManagedObjects<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, predicate: NSPredicate, fetchLimit: Int) -> [ManagedObject]?
    
    func fetchManagedObject<ManagedObject: NSManagedObject>(withObjectID objectID: NSManagedObjectID) throws -> ManagedObject?
    
    func fetchManagedObjects<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withObjectIDs objectIDs: [NSManagedObjectID]) -> [ManagedObject]?
    
    func fetchManagedObject<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withID id: String) -> ManagedObject?
    
    func deleteManagedObject(_ object: NSManagedObject)
    
    func commitChanges(onContext ContextType: ContextType?) throws
    
    func createFetchController<ManagedObject: NSManagedObject>(
        fetchRequest: NSFetchRequest<ManagedObject>,
        sectionNameKeyPath: String?,
        cacheName: String?
    ) -> NSFetchedResultsController<ManagedObject>
    
    func createFetchController<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<ManagedObject>) -> NSFetchedResultsController<ManagedObject>
    
    func prepareToMoveToDifferentThread(_ objects: [NSManagedObject]) throws -> [NSManagedObjectID]
    
    func dropEntity(entityName: String)
}
