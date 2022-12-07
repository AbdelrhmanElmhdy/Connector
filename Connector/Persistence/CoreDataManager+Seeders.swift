//
//  CoreDataManager+Seeders.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 01/08/2022.
//

import Foundation
import UIKit

class CoreDataSeeder: CoreDataManager {
    private let userServices: UserServicesProtocol
    
    init(userServices: UserServicesProtocol) {
        self.userServices = userServices
        super.init(persistentContainerName: "Connector")
    }
    
    func seedDatabase() {
        let contacts = seedContacts()
        let chatRooms = seedChatRooms(contacts: contacts)
        seedMessages(forChatRooms: chatRooms)

        try! context.save()
    }
    
    func seedContacts() -> [User] {
        var users: [User] = []
        
        for _ in 0...10 {
            let user = User(context: context)
            user.id = UUID().uuidString
            user.firstName = "Abdelrhman"
            user.lastName = "Elmahdy"
            user.username = "Abdelrhman\(Int.random(in: 0...1000))"
            user.email = "Abdelrhman\(Int.random(in: 0...1000))@gmail.com"
            
            users.append(user)
        }
        
        return users
    }
    
    func seedChatRooms(contacts: [User]) -> [ChatRoom] {
        var chatRooms: [ChatRoom] = []
        
        for contact in contacts {
            let remoteParticipant = contact
            let localParticipant = try! userServices.getCurrentUser()
            let participants = [remoteParticipant, localParticipant]
            
            let chatRoom = ChatRoom(context: context)
            chatRoom.id = UUID().uuidString
            chatRoom.participantsIDs = participants.map { $0.id }
            chatRoom.participants = Set(participants)
            
            chatRooms.append(chatRoom)
        }
        
        return chatRooms
    }
    
    @discardableResult func seedMessages(forChatRooms chatRooms: [ChatRoom]) -> [Message] {
        
        
        var messages: [Message] = []
        
        for chatRoom in chatRooms {
            let remoteParticipantId = chatRoom.partnersIDs.first!
            let localParticipantId = (try! userServices.getCurrentUser()).id
            
            for _ in 0...300 {
                let messageIsIncoming = Bool.random()
                let senderId = messageIsIncoming ? remoteParticipantId : localParticipantId
                
                let message = Message(senderId: senderId, roomId: chatRoom.id!, type: .text, text: "Hello, World!", isIncoming: messageIsIncoming, context: context)
                message.room = chatRoom
                chatRoom.lastMessageTimeStamp = message.sentDateUnixTimeStamp
                
                messages.append(message)
            }
        }
        
        return messages
    }
}
