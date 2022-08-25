//
//  ChatMessagesManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 10/07/2022.
//

import Foundation

class ChatMessagesManager {
    
    static let shared = ChatMessagesManager()
    
    func incomingMessagesHandler(messages: [Message]) {
        let usersFetchGroup = DispatchGroup()
        
        for message in messages {
            let (chatRoom, chatRoomIsNew) = CoreDataManager.getObject(ofType: ChatRoom.self, withId: message.roomId!)
            chatRoom.lastMessageTimeStamp = message.sentDateUnixTimeStamp
            chatRoom.setLastMessageLabel(message: message)
            message.room = chatRoom
            
            if chatRoomIsNew {
                chatRoom.participantsIDs = [message.senderId!, UserDefaultsManager.user!.id!]
                
                usersFetchGroup.enter()
                NetworkManager.fetchUser(withId: message.senderId!) { user, error in
                    guard let localUser = UserDefaultsManager.user, let remoteUser = user else { return }
                    chatRoom.participants = [localUser, remoteUser]
                    
                    usersFetchGroup.leave()
                }
            }
        }
        
        usersFetchGroup.notify(queue: DispatchQueue.main) {
            do {
                try CoreDataManager.commitChangesOnMainThread()
            } catch {
                ErrorManager.reportError(error)
            }
        }
        
    }
        
    func sendMessage(_ message: Message, chatRoomIsInitialized: Bool = true) throws {
        // Save message to database
        try CoreDataManager.commitChangesOnMainThread()
        
        if chatRoomIsInitialized {
            NetworkManager.sendMessage(message: message)
            return
        }
        
        NetworkManager.initializeChatRoom(message.room!, withMessage: message)
    }        
}
