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
  
  func makeUserStubs(_ desiredNumberOfUsers: Int) -> [User] {
      userStubsFactory.make(desiredNumberOfUsers)
  }
  
  func makeUserStub() -> User {
      makeUserStubs(1)[0]
  }
  
  func makeChatRoomStubs(_ desiredNumberOfChatRooms: Int) -> [ChatRoom] {
      let currentUser = makeUserStub()
      currentUser.isCurrentUser = true
      let users = makeUserStubs(desiredNumberOfChatRooms)
      
      return chatRoomStubsFactory.make(withUsers: users, currentUser: currentUser)
  }
  
  func makeChatRoomStub() -> ChatRoom {
      makeChatRoomStubs(1)[0]
  }
  
  func makeMessageStubs(_ desiredNumberOfMessages: Int) -> [Message] {
      let chatRoom = makeChatRoomStub()
      
      return messageStubsFactory.make(desiredNumberOfMessages, inChatRoom: chatRoom)
  }
  
  func makeMessageStub() -> Message {
      makeMessageStubs(1)[0]
  }
  
  func resetCoreDataContext() {
      context.reset()
  }
}
