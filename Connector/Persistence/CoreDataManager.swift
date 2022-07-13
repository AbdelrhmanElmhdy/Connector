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
    
    static func saveMessages(_ messages: [Message]) throws {
        for message in messages {
            guard message.managedObjectContext == context else {
                throw CoreDataError.invalidContext(context: "trying to save message(s)")
            }
        }
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.failedToSave(description: error.localizedDescription, context: "trying to save message(s)")
        }
    }
    
    static func saveMessage(_ message: Message) throws {
        do {
            try saveMessages([message])
        } catch {
            throw CoreDataError.failedToSave(description: error.localizedDescription, context: "trying to save message(s)")
        }
    }
    
    static func retrieveMessages(forRoomId roomId: UUID) throws -> [Message] {
        let request = Message.fetchRequest() as NSFetchRequest<Message>
        let predicate = NSPredicate(format: "%K == '\(roomId)'", #keyPath(Message.roomId))
        
        request.predicate = predicate
        
        do {
            let messages = try context.fetch(request)
            return messages
        } catch {
            throw CoreDataError.failedToRetrieve(description: error.localizedDescription, context: "trying to retrieve messages for roomId: \(roomId)")
        }
    }
    
    static func retrieveChatRoom(roomId: UUID) throws -> ChatRoom {
        let request = ChatRoom.fetchRequest() as NSFetchRequest<ChatRoom>
        let predicate = NSPredicate(format: "id == '\(roomId)'")
        
        request.predicate = predicate
        
        let errorContext = "trying to retrieve chatRoom of id: \(roomId)"
        
        do {
            let rooms = try context.fetch(request)
            guard !rooms.isEmpty else { throw CoreDataError.failedToRetrieve(description: "No room matches id \(roomId)", context: errorContext)}
            
            return rooms[0]
        } catch {
            throw CoreDataError.failedToRetrieve(description: error.localizedDescription, context: errorContext)
        }
    }
}
