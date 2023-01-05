//
//  ChatRoomStubsFactory.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 12/12/2022.
//

import Foundation
import CoreData
@testable import Connector

struct ChatRoomStubsFactory {
  let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
      self.context = context
  }
  
  func make(withUsers users: [User], currentUser: User) -> [ChatRoom] {
      var chatRooms = Array<ChatRoom>()
      
      for user in users {
        let chatRoom = ChatRoom(participants: [currentUser, user], context: context)!
        chatRooms.append(chatRoom)
      }
      
      return chatRooms
  }
}
