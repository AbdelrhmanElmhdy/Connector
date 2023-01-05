//
//  ChatRoomService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/12/2022.
//

import Foundation
import CoreData

protocol ChatRoomService: AutoMockable {  
	func createChatRoom(withParticipants participants: [User]) -> ChatRoom?
	
	func fetchChatRoom(withObjectID objectID: NSManagedObjectID) throws -> ChatRoom?
	
	func fetchChatRooms(withObjectIDs objectIDs: [NSManagedObjectID]) -> [ChatRoom]?
	
	func fetchChatRoom(withParticipantsIDs participantsIDs: [String]) -> ChatRoom?
	
	func createChatRoomsFetchController(fetchRequest: NSFetchRequest<ChatRoom>) -> NSFetchedResultsController<ChatRoom>
	
	func prepareToMoveChatRoomsToDifferentThread(_ objects: [ChatRoom]) throws -> [NSManagedObjectID]
}
