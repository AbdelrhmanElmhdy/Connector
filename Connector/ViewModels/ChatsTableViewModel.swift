//
//  ChatsTableViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 05/10/2022.
//

import Foundation
import CoreData

class ChatsTableViewModel {
	private let userService: UserService
	private let chatRoomService: ChatRoomService
	private let chatMessageService: ChatMessageService
	
	init(userService: UserService, chatRoomService: ChatRoomService, chatMessageService: ChatMessageService) {
		self.userService = userService
		self.chatRoomService = chatRoomService
		self.chatMessageService = chatMessageService
	}
	
	func startListeningForIncomingMessages() throws {
		try chatMessageService.startListeningForIncomingMessages()
	}
	
	func createChatRoomsFetchController(fetchRequest: NSFetchRequest<ChatRoom>) -> NSFetchedResultsController<ChatRoom> {
		chatRoomService.createChatRoomsFetchController(fetchRequest: fetchRequest)
	}
	
	func createNewChatRoom(withParticipants participants: [User]) -> ChatRoom? {
		chatRoomService.createChatRoom(withParticipants: participants)
	}
	
	func getExistingChatRoom(_ participantsIDs: [String]) -> ChatRoom? {
		chatRoomService.fetchChatRoom(withParticipantsIDs: participantsIDs)
	}
	
	func getCurrentUser() throws -> User { try userService.getCurrentUser() }
	
	func prepareToMoveUsersToDifferentThread(users: [User]) throws -> [NSManagedObjectID] {
		try userService.prepareToMoveUsersToDifferentThread(users)
	}
	
	func getExistingUsers(withObjectIDs objectIDs: [NSManagedObjectID]) -> [User]? {
		userService.fetchUsers(withObjectIDs: objectIDs)
	}
	
	func searchForUsers(by username: String, completion: @escaping ([User]?, Error?) -> Void) {
		userService.searchForRemoteUsers(withUsernameSimilarTo: username, handler: completion)
	}
}
