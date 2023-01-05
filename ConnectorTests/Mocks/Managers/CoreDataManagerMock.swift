// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import Foundation
import CoreData
@testable import Connector

class CoreDataManagerMock: CoreDataManagerProtocol {

  var persistentContainer: NSPersistentContainer {
      get { return underlyingPersistentContainer }
      set(value) { underlyingPersistentContainer = value }
  }
  var underlyingPersistentContainer: NSPersistentContainer!
  var mainThreadContext: NSManagedObjectContext {
      get { return underlyingMainThreadContext }
      set(value) { underlyingMainThreadContext = value }
  }
  var underlyingMainThreadContext: NSManagedObjectContext!
  var backgroundContext: NSManagedObjectContext {
      get { return underlyingBackgroundContext }
      set(value) { underlyingBackgroundContext = value }
  }
  var underlyingBackgroundContext: NSManagedObjectContext!
  var context: NSManagedObjectContext {
      get { return underlyingContext }
      set(value) { underlyingContext = value }
  }
  var underlyingContext: NSManagedObjectContext!

  static func printSqliteFilePath() {
      
  }
  
  //MARK: - createManagedObject<ManagedObject: NSManagedObject>

  var createManagedObjectOfTypeWithIDCallsCount = 0
  var createManagedObjectOfTypeWithIDCalled: Bool {
      return createManagedObjectOfTypeWithIDCallsCount > 0
  }
  var createManagedObjectOfTypeWithIDReceivedArguments: (type: NSManagedObject.Type, id: String)?
  var createManagedObjectOfTypeWithIDReceivedInvocations: [(type: NSManagedObject.Type, id: String)] = []
  var createManagedObjectOfTypeWithIDReturnValue: NSManagedObject?
  var createManagedObjectOfTypeWithIDClosure: ((NSManagedObject.Type, String) -> NSManagedObject?)?

  func createManagedObject<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withID id: String) -> ManagedObject? {
      createManagedObjectOfTypeWithIDCallsCount += 1
      createManagedObjectOfTypeWithIDReceivedArguments = (type: type, id: id)
      createManagedObjectOfTypeWithIDReceivedInvocations.append((type: type, id: id))
      if let closure = createManagedObjectOfTypeWithIDClosure as? ((ManagedObject.Type, String) -> ManagedObject?) {
        return closure(type, id)
      } else {
        return createManagedObjectOfTypeWithIDReturnValue as? ManagedObject
      }
  }

  //MARK: - fetchManagedObjects<ManagedObject: NSManagedObject>

  var fetchManagedObjectsFetchRequestCallsCount = 0
  var fetchManagedObjectsFetchRequestCalled: Bool {
      return fetchManagedObjectsFetchRequestCallsCount > 0
  }
  var fetchManagedObjectsFetchRequestReceivedFetchRequest: NSFetchRequest<NSFetchRequestResult>?
  var fetchManagedObjectsFetchRequestReceivedInvocations: [NSFetchRequest<NSFetchRequestResult>] = []
  var fetchManagedObjectsFetchRequestReturnValue: [NSManagedObject]?
  var fetchManagedObjectsFetchRequestClosure: ((NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]?)?

  func fetchManagedObjects<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [ManagedObject]? {
      fetchManagedObjectsFetchRequestCallsCount += 1
      fetchManagedObjectsFetchRequestReceivedFetchRequest = fetchRequest
      fetchManagedObjectsFetchRequestReceivedInvocations.append(fetchRequest)
      if let closure = fetchManagedObjectsFetchRequestClosure as? ((NSFetchRequest<NSFetchRequestResult>) -> [ManagedObject]?) {
        return closure(fetchRequest)
      } else {
        return fetchManagedObjectsFetchRequestReturnValue as? [ManagedObject]
      }
  }

  //MARK: - fetchManagedObjects<ManagedObject: NSManagedObject>

  var fetchManagedObjectsOfTypePredicateFetchLimitCallsCount = 0
  var fetchManagedObjectsOfTypePredicateFetchLimitCalled: Bool {
      return fetchManagedObjectsOfTypePredicateFetchLimitCallsCount > 0
  }
  var fetchManagedObjectsOfTypePredicateFetchLimitReceivedArguments: (type: NSManagedObject.Type, predicate: NSPredicate, fetchLimit: Int)?
  var fetchManagedObjectsOfTypePredicateFetchLimitReceivedInvocations: [(type: NSManagedObject.Type, predicate: NSPredicate, fetchLimit: Int)] = []
  var fetchManagedObjectsOfTypePredicateFetchLimitReturnValue: [NSManagedObject]?
  var fetchManagedObjectsOfTypePredicateFetchLimitClosure: ((NSManagedObject.Type, NSPredicate, Int) -> [NSManagedObject]?)?

  func fetchManagedObjects<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, predicate: NSPredicate, fetchLimit: Int) -> [ManagedObject]? {
      fetchManagedObjectsOfTypePredicateFetchLimitCallsCount += 1
      fetchManagedObjectsOfTypePredicateFetchLimitReceivedArguments = (type: type, predicate: predicate, fetchLimit: fetchLimit)
      fetchManagedObjectsOfTypePredicateFetchLimitReceivedInvocations.append((type: type, predicate: predicate, fetchLimit: fetchLimit))
      if let closure = fetchManagedObjectsOfTypePredicateFetchLimitClosure as? ((ManagedObject.Type, NSPredicate, Int) -> [ManagedObject]?) {
        return closure(type, predicate, fetchLimit)
      } else {
        return fetchManagedObjectsOfTypePredicateFetchLimitReturnValue as? [ManagedObject]
      }
  }

  //MARK: - fetchManagedObject<ManagedObject: NSManagedObject>

  var fetchManagedObjectWithObjectIDThrowableError: Error?
  var fetchManagedObjectWithObjectIDCallsCount = 0
  var fetchManagedObjectWithObjectIDCalled: Bool {
      return fetchManagedObjectWithObjectIDCallsCount > 0
  }
  var fetchManagedObjectWithObjectIDReceivedObjectID: NSManagedObjectID?
  var fetchManagedObjectWithObjectIDReceivedInvocations: [NSManagedObjectID] = []
  var fetchManagedObjectWithObjectIDReturnValue: NSManagedObject?
  var fetchManagedObjectWithObjectIDClosure: ((NSManagedObjectID) throws -> NSManagedObject?)?

  func fetchManagedObject<ManagedObject: NSManagedObject>(withObjectID objectID: NSManagedObjectID) throws -> ManagedObject? {
      if let error = fetchManagedObjectWithObjectIDThrowableError {
        throw error
      }
      fetchManagedObjectWithObjectIDCallsCount += 1
      fetchManagedObjectWithObjectIDReceivedObjectID = objectID
      fetchManagedObjectWithObjectIDReceivedInvocations.append(objectID)
      if let closure = fetchManagedObjectWithObjectIDClosure as? ((NSManagedObjectID) throws -> ManagedObject?) {
        return try closure(objectID)
      } else {
        return fetchManagedObjectWithObjectIDReturnValue as? ManagedObject
      }
  }

  //MARK: - fetchManagedObjects<ManagedObject: NSManagedObject>

  var fetchManagedObjectsOfTypeWithObjectIDsCallsCount = 0
  var fetchManagedObjectsOfTypeWithObjectIDsCalled: Bool {
      return fetchManagedObjectsOfTypeWithObjectIDsCallsCount > 0
  }
  var fetchManagedObjectsOfTypeWithObjectIDsReceivedArguments: (type: NSManagedObject.Type, objectIDs: [NSManagedObjectID])?
  var fetchManagedObjectsOfTypeWithObjectIDsReceivedInvocations: [(type: NSManagedObject.Type, objectIDs: [NSManagedObjectID])] = []
  var fetchManagedObjectsOfTypeWithObjectIDsReturnValue: [NSManagedObject]?
  var fetchManagedObjectsOfTypeWithObjectIDsClosure: ((NSManagedObject.Type, [NSManagedObjectID]) -> [NSManagedObject]?)?

  func fetchManagedObjects<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withObjectIDs objectIDs: [NSManagedObjectID]) -> [ManagedObject]? {
      fetchManagedObjectsOfTypeWithObjectIDsCallsCount += 1
      fetchManagedObjectsOfTypeWithObjectIDsReceivedArguments = (type: type, objectIDs: objectIDs)
      fetchManagedObjectsOfTypeWithObjectIDsReceivedInvocations.append((type: type, objectIDs: objectIDs))
      if let closure = fetchManagedObjectsOfTypeWithObjectIDsClosure as? ((ManagedObject.Type, [NSManagedObjectID]) -> [ManagedObject]?) {
        return closure(type, objectIDs)
      } else {
        return fetchManagedObjectsOfTypeWithObjectIDsReturnValue as? [ManagedObject]
      }
  }

  //MARK: - fetchManagedObject<ManagedObject: NSManagedObject>

  var fetchManagedObjectOfTypeWithIDCallsCount = 0
  var fetchManagedObjectOfTypeWithIDCalled: Bool {
      return fetchManagedObjectOfTypeWithIDCallsCount > 0
  }
  var fetchManagedObjectOfTypeWithIDReceivedArguments: (type: NSManagedObject.Type, id: String)?
  var fetchManagedObjectOfTypeWithIDReceivedInvocations: [(type: NSManagedObject.Type, id: String)] = []
  var fetchManagedObjectOfTypeWithIDReturnValue: NSManagedObject?
  var fetchManagedObjectOfTypeWithIDClosure: ((NSManagedObject.Type, String) -> NSManagedObject?)?

  func fetchManagedObject<ManagedObject: NSManagedObject>(ofType type: ManagedObject.Type, withID id: String) -> ManagedObject? {
      fetchManagedObjectOfTypeWithIDCallsCount += 1
      fetchManagedObjectOfTypeWithIDReceivedArguments = (type: type, id: id)
      fetchManagedObjectOfTypeWithIDReceivedInvocations.append((type: type, id: id))
      if let closure = fetchManagedObjectOfTypeWithIDClosure as? ((ManagedObject.Type, String) -> ManagedObject?) {
        return closure(type, id)
      } else {
        return fetchManagedObjectOfTypeWithIDReturnValue as? ManagedObject
      }
  }

  //MARK: - deleteManagedObject

  var deleteManagedObjectCallsCount = 0
  var deleteManagedObjectCalled: Bool {
      return deleteManagedObjectCallsCount > 0
  }
  var deleteManagedObjectReceivedObject: NSManagedObject?
  var deleteManagedObjectReceivedInvocations: [NSManagedObject] = []
  var deleteManagedObjectClosure: ((NSManagedObject) -> Void)?

  func deleteManagedObject(_ object: NSManagedObject) {
      deleteManagedObjectCallsCount += 1
      deleteManagedObjectReceivedObject = object
      deleteManagedObjectReceivedInvocations.append(object)
      deleteManagedObjectClosure?(object)
  }

  //MARK: - commitChanges

  var commitChangesOnContextThrowableError: Error?
  var commitChangesOnContextCallsCount = 0
  var commitChangesOnContextCalled: Bool {
      return commitChangesOnContextCallsCount > 0
  }
  var commitChangesOnContextReceivedContextType: ContextType?
  var commitChangesOnContextReceivedInvocations: [ContextType?] = []
  var commitChangesOnContextClosure: ((ContextType?) throws -> Void)?

  func commitChanges(onContext ContextType: ContextType?) throws {
      if let error = commitChangesOnContextThrowableError {
        throw error
      }
      commitChangesOnContextCallsCount += 1
      commitChangesOnContextReceivedContextType = ContextType
      commitChangesOnContextReceivedInvocations.append(ContextType)
      try commitChangesOnContextClosure?(ContextType)
  }

  //MARK: - createFetchController<ManagedObject: NSManagedObject>

  var createFetchControllerFetchRequestSectionNameKeyPathCacheNameCallsCount = 0
  var createFetchControllerFetchRequestSectionNameKeyPathCacheNameCalled: Bool {
      return createFetchControllerFetchRequestSectionNameKeyPathCacheNameCallsCount > 0
  }
  var createFetchControllerFetchRequestSectionNameKeyPathCacheNameReceivedArguments: (fetchRequest: Any, sectionNameKeyPath: String?, cacheName: String?)?
  var createFetchControllerFetchRequestSectionNameKeyPathCacheNameReceivedInvocations: [(fetchRequest: Any, sectionNameKeyPath: String?, cacheName: String?)] = []
  var createFetchControllerFetchRequestSectionNameKeyPathCacheNameReturnValue: NSFetchedResultsController<NSFetchRequestResult>!
  var createFetchControllerFetchRequestSectionNameKeyPathCacheNameClosure: ((NSFetchRequest<NSManagedObject>, String?, String?) -> NSFetchedResultsController<NSManagedObject>)?

  func createFetchController<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<ManagedObject>, sectionNameKeyPath: String?, cacheName: String?) -> NSFetchedResultsController<ManagedObject> {
      createFetchControllerFetchRequestSectionNameKeyPathCacheNameCallsCount += 1
      createFetchControllerFetchRequestSectionNameKeyPathCacheNameReceivedArguments = (fetchRequest: fetchRequest, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
      createFetchControllerFetchRequestSectionNameKeyPathCacheNameReceivedInvocations.append((fetchRequest: fetchRequest, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName))
      if let closure = createFetchControllerFetchRequestSectionNameKeyPathCacheNameClosure as? ((NSFetchRequest<ManagedObject>, String?, String?) -> NSFetchedResultsController<ManagedObject>) {
        return closure(fetchRequest, sectionNameKeyPath, cacheName)
      } else {
        return createFetchControllerFetchRequestSectionNameKeyPathCacheNameReturnValue as! NSFetchedResultsController<ManagedObject>
      }
  }

  //MARK: - createFetchController<ManagedObject: NSManagedObject>

  var createFetchControllerFetchRequestCallsCount = 0
  var createFetchControllerFetchRequestCalled: Bool {
      return createFetchControllerFetchRequestCallsCount > 0
  }
  var createFetchControllerFetchRequestReceivedFetchRequest: Any?
  var createFetchControllerFetchRequestReceivedInvocations: [Any] = []
  var createFetchControllerFetchRequestReturnValue: NSFetchedResultsController<NSManagedObject>!
  var createFetchControllerFetchRequestClosure: ((NSFetchRequest<NSManagedObject>) -> NSFetchedResultsController<NSManagedObject>)?

  func createFetchController<ManagedObject: NSManagedObject>(fetchRequest: NSFetchRequest<ManagedObject>) -> NSFetchedResultsController<ManagedObject> {
      createFetchControllerFetchRequestCallsCount += 1
      createFetchControllerFetchRequestReceivedFetchRequest = fetchRequest
      createFetchControllerFetchRequestReceivedInvocations.append(fetchRequest)
      if let closure = createFetchControllerFetchRequestClosure as? ((NSFetchRequest<ManagedObject>) -> NSFetchedResultsController<ManagedObject>) {
        return closure(fetchRequest)
      } else {
        return createFetchControllerFetchRequestReturnValue as! NSFetchedResultsController<ManagedObject>
      }
  }

  //MARK: - prepareToMoveToDifferentThread

  var prepareToMoveToDifferentThreadThrowableError: Error?
  var prepareToMoveToDifferentThreadCallsCount = 0
  var prepareToMoveToDifferentThreadCalled: Bool {
      return prepareToMoveToDifferentThreadCallsCount > 0
  }
  var prepareToMoveToDifferentThreadReceivedObjects: [NSManagedObject]?
  var prepareToMoveToDifferentThreadReceivedInvocations: [[NSManagedObject]] = []
  var prepareToMoveToDifferentThreadReturnValue: [NSManagedObjectID]!
  var prepareToMoveToDifferentThreadClosure: (([NSManagedObject]) throws -> [NSManagedObjectID])?

  func prepareToMoveToDifferentThread(_ objects: [NSManagedObject]) throws -> [NSManagedObjectID] {
      if let error = prepareToMoveToDifferentThreadThrowableError {
        throw error
      }
      prepareToMoveToDifferentThreadCallsCount += 1
      prepareToMoveToDifferentThreadReceivedObjects = objects
      prepareToMoveToDifferentThreadReceivedInvocations.append(objects)
      if let prepareToMoveToDifferentThreadClosure = prepareToMoveToDifferentThreadClosure {
        return try prepareToMoveToDifferentThreadClosure(objects)
      } else {
        return prepareToMoveToDifferentThreadReturnValue
      }
  }

  //MARK: - dropEntity

  var dropEntityEntityNameCallsCount = 0
  var dropEntityEntityNameCalled: Bool {
      return dropEntityEntityNameCallsCount > 0
  }
  var dropEntityEntityNameReceivedEntityName: String?
  var dropEntityEntityNameReceivedInvocations: [String] = []
  var dropEntityEntityNameClosure: ((String) -> Void)?

  func dropEntity(entityName: String) {
      dropEntityEntityNameCallsCount += 1
      dropEntityEntityNameReceivedEntityName = entityName
      dropEntityEntityNameReceivedInvocations.append(entityName)
      dropEntityEntityNameClosure?(entityName)
  }

}
