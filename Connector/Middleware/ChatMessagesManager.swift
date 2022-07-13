//
//  ChatMessagesManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 10/07/2022.
//

import Foundation

class ChatMessagesManager {
    
    static let shared = ChatMessagesManager()
    
    enum Event {
        case incomingMessage
        case outgoingMessage
    }
    
    private lazy var observers: [Observer] = []
    
    private init() {
        NetworkManager.listenForIncomingMessages(completionHandler: incomingMessagesHandler)
    }
    
    func incomingMessagesHandler(messages: [Message]) {
        // Save message to database
        try! CoreDataManager.saveMessages(messages)
        
        // Broadcast incomingMessage event to observers
        for observer in observers {
            observer.update(event: .incomingMessage)
        }
    }
    
    func sendMessage(_ message: Message) throws {
        // Save message to database
        try CoreDataManager.saveMessage(message)
        
        // Broadcast outgoingMessage event to observers
        for observer in observers {
            observer.update(event: .outgoingMessage)
        }
        
        NetworkManager.sendMessage(message: message) {
            // Alter the message in the database and save its sentDateUnixTimeStamp
            message.sentDateUnixTimeStamp = Date.now.timeIntervalSince1970
            try? CoreDataManager.saveMessage(message)
        }
    }
        
    func addObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: Observer) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
}
