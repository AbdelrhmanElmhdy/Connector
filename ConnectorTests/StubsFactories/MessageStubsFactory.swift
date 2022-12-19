//
//  MessageStubsFactory.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 12/12/2022.
//


import Foundation
import CoreData
import Fakery
@testable import Connector

struct MessageStubsFactory {
    let context: NSManagedObjectContext
    let faker: Faker
    
    init(context: NSManagedObjectContext, faker: Faker) {
        self.context = context
        self.faker = faker
    }
    
    /// - Note: Adds the created messages to the chat room.
    @discardableResult func create(_ desiredNumberOfMessages: Int, inChatRoom chatRoom: ChatRoom) -> [Message] {
        var messages = Array<Message>()
        
        for _ in 0...desiredNumberOfMessages {
            
            let isIncoming = Bool.random()
            let senderId = isIncoming
                ? chatRoom.partnersIDs[0]
                : chatRoom.participants!.filter { $0.isCurrentUser }.first!.id
            
            let roomId = chatRoom.id!
            let text = Bool.random() ? faker.lorem.sentence() : faker.lorem.paragraph(sentencesAmount: 3)
            
            let message: Message = Message(
                senderId: senderId,
                roomId: roomId,
                type: .text,
                text: text,
                isIncoming: isIncoming,
                context: context
            )
            
            message.room = chatRoom
            
            messages.append(message)
        }
        
        return messages
    }
}
