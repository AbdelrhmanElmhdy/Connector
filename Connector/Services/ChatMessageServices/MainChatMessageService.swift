//
//  MainChatMessageService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 10/07/2022.
//

import CoreData

class MainChatMessageService: ChatMessageService {
	
	private var coreDataManager: CoreDataManagerProtocol
	private var chatMessageNetworkService: ChatMessageNetworkService
	private var userService: UserService
	private var authService: AuthService
	
	init(coreDataManager: CoreDataManagerProtocol, chatMessageNetworkService: ChatMessageNetworkService, userService: UserService, authService: AuthService) {
		self.coreDataManager = coreDataManager
		self.chatMessageNetworkService = chatMessageNetworkService
		self.userService = userService
		self.authService = authService
	}
	
	func createMessage(
		senderId: String,
		roomId: String,
		repliedAtMessageId: String? = nil,
		type: Message.MessageType,
		text: String? = nil,
		mediaOrFileURL: URL? = nil,
		location: Location? = nil,
		contact: Contact? = nil
	) -> Message {
		let isIncoming = authService.userId == senderId
		
		return Message(senderId: senderId, roomId: roomId, repliedAtMessageId: repliedAtMessageId, type: type, text: text, mediaOrFileURL: mediaOrFileURL, location: location, contact: contact, isIncoming: isIncoming, context: coreDataManager.context)
	}
	
	func fetchMessage(withObjectID objectID: NSManagedObjectID) throws -> Message? {
		return try coreDataManager.fetchManagedObject(withObjectID: objectID)
	}
	
	func fetchMessages(withObjectIDs objectIDs: [NSManagedObjectID]) -> [Message]? {
		return coreDataManager.fetchManagedObjects(ofType: Message.self, withObjectIDs: objectIDs)
	}
	
	func startListeningForIncomingMessages() throws {
		let currentUser = try userService.getCurrentUser()
		
		chatMessageNetworkService.listenForIncomingMessages(completionHandler: incomingMessagesHandler,
																												currentUserId: currentUser.id,
																												managedObjectContext: coreDataManager.backgroundContext)
	}
	
	func stopListeningForIncomingMessages() {
		chatMessageNetworkService.stopListeningForIncomingMessages()
	}
	
	func incomingMessagesHandler(messages: [Message]) {
		guard !messages.isEmpty else { return }
		
		let usersFetchGroup = DispatchGroup()
		
		for message in messages {
			guard let roomId = message.roomId else { continue }
			let chatRoom: ChatRoom?, chatRoomExists: Bool
			
			let existingChatRoom = coreDataManager.fetchManagedObject(ofType: ChatRoom.self, withID: roomId)
			
			if let existingChatRoom = existingChatRoom {
				chatRoom = existingChatRoom
				chatRoomExists = true
			} else {
				chatRoom = coreDataManager.createManagedObject(ofType: ChatRoom.self, withID: roomId)
				chatRoomExists = false
			}
			
			guard let chatRoom = chatRoom else { continue }
			
			message.room = chatRoom
			chatRoom.lastMessageTimeStamp = message.sentDateUnixTimeStamp
			chatRoom.setLastMessageLabel(message: message)
			
			if !chatRoomExists {
				let currentUser: User
				
				do { currentUser = try userService.getCurrentUser() }
				catch { ErrorManager.shared.reportError(error); return; }
				
				chatRoom.participantsIDs = [message.senderId!, currentUser.id]
				
				usersFetchGroup.enter()
				userService.fetchRemoteUser(withId: message.senderId!) { user, error in
					guard let remoteUser = user else { return }
					chatRoom.participants = [currentUser, remoteUser]
					
					usersFetchGroup.leave()
				}
			} else {
				do { try self.coreDataManager.commitChanges(onContext: .background) }
				catch { ErrorManager.shared.reportError(error) }
			}
		}
		
		usersFetchGroup.notify(queue: DispatchQueue.main) {
			do { try self.coreDataManager.commitChanges(onContext: .background) }
			catch { ErrorManager.shared.reportError(error) }
		}
	}
	
	func sendMessage(_ message: Message) throws {
		defer {
			message.room?.lastMessageTimeStamp = message.sentDateUnixTimeStamp
			message.room?.setLastMessageLabel(message: message)
			try? coreDataManager.commitChanges(onContext: .auto)
		}
		
		let chatRoomIsInitialized = message.room?.isInitialized ?? false
		
		if chatRoomIsInitialized {
			chatMessageNetworkService.sendMessage(message: message)
			return
		}
		
		chatMessageNetworkService.initializeChatRoom(message.room!, withMessage: message)
	}
	
	func deleteMessage(_ message: Message) {
		coreDataManager.deleteManagedObject(message)
	}
	
	func deleteMessageAndAmendChatRoom(_ message: Message, previousMessage: Message?) {
		if let chatRoom = message.room {
			chatRoom.setLastMessageLabel(message: previousMessage)
			chatRoom.lastMessageTimeStamp = previousMessage?.sentDateUnixTimeStamp ?? -1
		}
		
		deleteMessage(message)
	}
	
	func createMessagesFetchController(fetchRequest: NSFetchRequest<Message>) -> NSFetchedResultsController<Message> {
		coreDataManager.createFetchController(fetchRequest: fetchRequest)
	}
	
	func prepareToMoveMessagesToDifferentThread(_ objects: [Message]) throws -> [NSManagedObjectID] {
		try coreDataManager.prepareToMoveToDifferentThread(objects)
	}
}
