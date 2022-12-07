//
//  ChatsTableViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 05/10/2022.
//

import Foundation
import CoreData

class ChatsTableViewModel {
    private let userServices: UserServicesProtocol
    private let chatRoomServices: ChatRoomServicesProtocol
    private let chatMessageServices: ChatMessageServicesProtocol
            
    init(userServices: UserServicesProtocol, chatRoomServices: ChatRoomServicesProtocol, chatMessageServices: ChatMessageServicesProtocol) {
        self.userServices = userServices
        self.chatRoomServices = chatRoomServices
        self.chatMessageServices = chatMessageServices
    }
    
    func startListeningForIncomingMessages() throws {
        try chatMessageServices.startListeningForIncomingMessages()
    }
    
    func createChatRoomsFetchController(fetchRequest: NSFetchRequest<ChatRoom>) -> NSFetchedResultsController<ChatRoom> {
        chatRoomServices.createChatRoomsFetchController(fetchRequest: fetchRequest)
    }
    
    func createNewChatRoom(withParticipants participants: [User]) -> ChatRoom? {
        chatRoomServices.createChatRoom(withParticipants: participants)
    }
    
    func getExistingChatRoom(_ participantsIDs: [String]) -> ChatRoom? {
        chatRoomServices.fetchChatRoom(withParticipantsIDs: participantsIDs)
    }
    
    func getCurrentUser() throws -> User { try userServices.getCurrentUser() }
    
    func prepareToMoveUsersToDifferentThread(users: [User]) throws -> [NSManagedObjectID] {
        try userServices.prepareToMoveUsersToDifferentThread(users)
    }
    
    func getExistingUsers(withObjectIDs objectIDs: [NSManagedObjectID]) -> [User]? {
        userServices.fetchUsers(withObjectIDs: objectIDs)
    }
    
    func searchForUsers(by username: String, completion: @escaping ([User]?, Error?) -> Void) {
        userServices.searchForRemoteUsers(withUsernameSimilarTo: username, handler: completion)
    }
}
