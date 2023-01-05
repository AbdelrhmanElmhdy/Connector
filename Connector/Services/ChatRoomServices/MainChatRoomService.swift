//
//  MainChatRoomService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 27/11/2022.
//

import Foundation
import CoreData

class MainChatRoomService: ChatRoomService {
	private let coreDataManager: CoreDataManagerProtocol
	
	init(coreDataManager: CoreDataManagerProtocol) {
		self.coreDataManager = coreDataManager
	}
	
	func createChatRoom(withParticipants participants: [User]) -> ChatRoom? {
		ChatRoom(participants: participants, context: coreDataManager.context)
	}
	
	func fetchChatRoom(withObjectID objectID: NSManagedObjectID) throws -> ChatRoom? {
		try coreDataManager.fetchManagedObject(withObjectID: objectID)
	}
	
	func fetchChatRooms(withObjectIDs objectIDs: [NSManagedObjectID]) -> [ChatRoom]? {
		coreDataManager.fetchManagedObjects(ofType: ChatRoom.self, withObjectIDs: objectIDs)
	}
	
	func fetchChatRoom(withParticipantsIDs participantsIDs: [String]) -> ChatRoom? {
		let predicate = NSPredicate(format: "%K == %@", #keyPath(ChatRoom.participantsIDs), participantsIDs)
		return coreDataManager.fetchManagedObjects(ofType: ChatRoom.self, predicate: predicate, fetchLimit: 1)?.first
	}
	
	func createChatRoomsFetchController(fetchRequest: NSFetchRequest<ChatRoom>) -> NSFetchedResultsController<ChatRoom> {
		coreDataManager.createFetchController(fetchRequest: fetchRequest)
	}
	
	func prepareToMoveChatRoomsToDifferentThread(_ objects: [ChatRoom]) throws -> [NSManagedObjectID] {
		try coreDataManager.prepareToMoveToDifferentThread(objects)
	}
}
