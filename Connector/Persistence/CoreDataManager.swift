//
//  CoreDataManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManager {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    static func fetchUsers(withIDs userIds: [String]) throws -> [User] {
        var users: [User] = []
        
        for userId in userIds {
            if let user = try fetchUser(withId: userId) {
                users.append(user)
            }
        }
        
        return users
    }
    
    static func fetchUser(withId userId: String) throws -> User? {
        let request: NSFetchRequest<User> = {
            let predicate = NSPredicate(format: "id == %@", userId)
            let request = User.fetchRequest()
            request.fetchLimit = 1
            request.predicate = predicate
            return request
        }()
        
        
        do {
            let user = try context.fetch(request).first
            return user
        } catch {
            throw CoreDataError.failedToRetrieve(description: error.localizedDescription)
        }
    }
    
    static func fetchChatRoom(withParticipantsIDs participantsIDs: [String]) throws -> ChatRoom {
        let request = ChatRoom.fetchRequest()
        let exactParticipantsIDs = participantsIDs + [UserDefaultsManager.user!.id!]
        let predicate = NSPredicate(format: "%K == '\(exactParticipantsIDs)'", #keyPath(ChatRoom.participantsIDs))
        request.predicate = predicate
        
        do {
            let rooms = try context.fetch(request)
            guard let room = rooms.first else { throw CoreDataError.failedToRetrieve(description: "No room with participantsIDs \(participantsIDs)")}
            return room
        } catch {
            throw CoreDataError.failedToRetrieve(description: error.localizedDescription)
        }
    }
    
    static func commitChangesOnMainThread() throws {
        try context.performAndWait {
            try context.save()
        }
    }
    
    static func getObject<ManagedObject: NSManagedObject>(ofType: ManagedObject.Type, withId id: String) -> (object: ManagedObject, objectIsNew: Bool) {
        func createNewObject() -> (object: ManagedObject, objectIsNew: Bool) {
            let newObject = ManagedObject(context: context)
            newObject.setValue(id, forKey: "id")
            return (object: newObject, objectIsNew: true)
        }
        
        guard ManagedObject.entity().attributesByName["id"] != nil else { return createNewObject() }
        
        let fetchRequest = ofType.fetchRequest()
        let predicate = NSPredicate(format: "id == '\(id)'")
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchedObjectResult = try context.fetch(fetchRequest)
            guard let fetchedObject = fetchedObjectResult.first as? ManagedObject else { return createNewObject() }
            return (object: fetchedObject, objectIsNew: false)
        } catch {
            return createNewObject()
        }
        
        
    }
}
