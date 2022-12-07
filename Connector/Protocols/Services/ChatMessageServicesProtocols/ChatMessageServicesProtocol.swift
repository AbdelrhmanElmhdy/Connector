//
//  ChatMessageServicesProtocol.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/12/2022.
//

import Foundation
import CoreData

protocol ChatMessageServicesProtocol {
    init (coreDataManager: CoreDataManager, chatMessageNetworkServices: ChatMessageNetworkServicesProtocol, userServices: UserServicesProtocol, authServices: AuthServicesProtocol)
    
    func createMessage(
        senderId: String,
        roomId: String,
        repliedAtMessageId: String?,
        type: Message.MessageType,
        text: String?,
        mediaOrFileURL: URL?,
        location: Location?,
        contact: Contact?,
        interactionType: Message.InteractionType?
    ) -> Message
    
    func fetchMessage(withObjectID objectID: NSManagedObjectID) throws -> Message?
    
    func fetchMessages(withObjectIDs objectIDs: [NSManagedObjectID]) -> [Message]?
    
    func startListeningForIncomingMessages() throws
    
    func stopListeningForIncomingMessages()
    
    func incomingMessagesHandler(messages: [Message])
    
    func sendMessage(_ message: Message) throws
    
    func deleteMessage(_ message: Message)
    
    func deleteMessageAndAmendChatRoom(_ message: Message, previousMessage: Message?)
    
    func createMessagesFetchController(fetchRequest: NSFetchRequest<Message>) -> NSFetchedResultsController<Message>
    
    func prepareToMoveMessagesToDifferentThread(_ objects: [Message]) throws -> [NSManagedObjectID]
}
