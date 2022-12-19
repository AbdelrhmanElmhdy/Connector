//
//  StubsFactory.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 18/12/2022.
//

import Foundation
import CoreData
import Fakery
@testable import Connector

struct StubsFactory {
    private let faker = Faker(locale: Locale.preferredLanguages[0])
    
    let context: NSManagedObjectContext
    
    let userStubsFactory: UserStubsFactory
    let chatRoomStubsFactory: ChatRoomStubsFactory
    let messageStubsFactory: MessageStubsFactory
    
    init(context: NSManagedObjectContext) {
        self.context = context
        userStubsFactory = UserStubsFactory(context: context, faker: faker)
        chatRoomStubsFactory = ChatRoomStubsFactory(context: context)
        messageStubsFactory = MessageStubsFactory(context: context, faker: faker)
    }
    
    func createUserStubs(_ desiredNumberOfUsers: Int) -> [User] {
        userStubsFactory.create(desiredNumberOfUsers)
    }
    
    func createUserStub() -> User {
        createUserStubs(1)[0]
    }
    
    func createChatRoomStubs(_ desiredNumberOfChatRooms: Int) -> [ChatRoom] {
        let currentUser = createUserStub()
        currentUser.isCurrentUser = true
        let users = createUserStubs(desiredNumberOfChatRooms)
        
        return chatRoomStubsFactory.create(withUsers: users, currentUser: currentUser)
    }
    
    func createChatRoomStub() -> ChatRoom {
        createChatRoomStubs(1)[0]
    }
    
    func createMessageStubs(_ desiredNumberOfMessages: Int) -> [Message] {
        let chatRoom = createChatRoomStub()
        
        return messageStubsFactory.create(desiredNumberOfMessages, inChatRoom: chatRoom)
    }
    
    func createMessageStub() -> Message {
        createMessageStubs(1)[0]
    }
    
    func resetCoreDataContext() {
        context.reset()
    }
}
