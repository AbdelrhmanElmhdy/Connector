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
    private let chatMessageServices: ChatMessageServicesProtocol
    private let userServices: UserServicesProtocol
    
    @Published var messageText: String = ""
    
    init(chatMessageServices: ChatMessageServicesProtocol, userServices: UserServicesProtocol) {
        self.chatMessageServices = chatMessageServices
        self.userServices = userServices
    }
    
    func createMessagesFetchController(fetchRequest: NSFetchRequest<Message>) -> NSFetchedResultsController<Message> {
        chatMessageServices.createMessagesFetchController(fetchRequest: fetchRequest)
    }
    
    func getCurrentUser() throws -> User { try userServices.getCurrentUser() }
    
    func createMessage(in chatRoom: ChatRoom, senderId: String, roomId: String, type: Message.MessageType, text: String) -> Message {
        let message = chatMessageServices.createMessage(
            senderId: senderId,
            roomId: roomId,
            repliedAtMessageId: nil,
            type: type,
            text: text,
            mediaOrFileURL: nil,
            location: nil,
            contact: nil,
            interactionType: nil
        )
        
        message.room = chatRoom
        
        return message
    }
    
    func sendMessage(message: Message) throws {
        try chatMessageServices.sendMessage(message)
    }
    
    func deleteMessage(_ message: Message) {
        chatMessageServices.deleteMessage(message)
    }
    
}
