//
//  ChatRoomViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 05/10/2022.
//

import Foundation
import Combine
import CoreData

class ChatRoomViewModel {
	private let chatMessageService: ChatMessageService
	private let userService: UserService
	
	@Published var messageText: String = ""
	
	init(chatMessageService: ChatMessageService, userService: UserService) {
		self.chatMessageService = chatMessageService
		self.userService = userService
	}
	
	func createMessagesFetchController(fetchRequest: NSFetchRequest<Message>) -> NSFetchedResultsController<Message> {
		chatMessageService.createMessagesFetchController(fetchRequest: fetchRequest)
	}
	
	func getCurrentUser() throws -> User { try userService.getCurrentUser() }
	
	func createMessage(in chatRoom: ChatRoom, senderId: String, roomId: String, type: Message.MessageType, text: String) -> Message {
		let message = chatMessageService.createMessage(
			senderId: senderId,
			roomId: roomId,
			repliedAtMessageId: nil,
			type: type,
			text: text,
			mediaOrFileURL: nil,
			location: nil,
			contact: nil
		)
		
		message.room = chatRoom
		
		return message
	}
	
	func sendMessage(message: Message) throws {
		try chatMessageService.sendMessage(message)
	}
	
	func deleteMessage(_ message: Message) {
		chatMessageService.deleteMessage(message)
	} 
	
}
