//
//  Room.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import Foundation

import Foundation
import CoreData

@objc(ChatRoom)
public class ChatRoom: NSManagedObject, Codable {
    
    enum CodingKeys: CodingKey {
        case id, participantsIDs, messages, groupChatImageUrl
    }
    
    // MARK: Initialization
    
    convenience init?(participants: [User], context: NSManagedObjectContext) {
        guard participants.count > 1 else { return nil }
        
        self.init(context: context)
        
        self.participantsIDs = participants.map { $0.id }
        self.participants = Set(participants)
        
        let chatRoomIsPrivate = participants.count == 2
                
        if chatRoomIsPrivate {
            // When chat room is private give it an id that's dependent on the users IDs to
            // make sure only one chat room could ever exist between the same two users.
            self.id = participantsIDs!.sorted().joined(separator: "-")
        } else { // Chat room is a group chat.
            self.id = UUID().uuidString
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataError.decoderMissingManagedObjectContext()
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.participantsIDs = try container.decode([String].self, forKey: .participantsIDs)
        self.groupChatImageUrl = try container.decode(String.self, forKey: .groupChatImageUrl)
        self.messages = try container.decode(Set<Message>.self, forKey: .messages) as Set<Message>
    }
    
    // MARK: Properties
    
    /// Describes whether or not this chat room is between only two persons
    var isChatBinary: Bool {
        guard let participantsIDs = participantsIDs else { return false }
        return participantsIDs.count == 2
    }
    
    private var currentUser: User? {
        guard let participants = participants else { return nil }
        return participants.filter { $0.isCurrentUser }.first
    }
    
    /// The IDs of all the other partners in the chat room not including the current user's ID
    var partnersIDs: [String] {
        guard let currentUser = currentUser, let participantsIDs = participantsIDs else { return [] }
        
        return participantsIDs.filter { $0 != currentUser.id }
    }
    
    var partners: [User] {
        guard let currentUser = currentUser, let participants = participants else { return [] }
        
        return participants.filter { $0 != currentUser }
    }
    
    var chatThumbnailImageURL: URL? {
        guard isChatBinary else { return URL(string: groupChatImageUrl ?? "") }
        
        return partners.first?.thumbnailImageUrl
    }
    
    var chatImageURL: URL? {
        guard isChatBinary else { return URL(string: groupChatImageUrl ?? "") }
        
        return partners.first?.imageUrl
    }
    
    var chatName: String {
        guard isChatBinary else { return groupChatName ?? "Group Chat".localized }
        
        let partnerName = partners.first?.name ?? ""
        
        return partnerName
    }
    
    var lastMessageDate: Date? {
        return Date(timeIntervalSince1970: lastMessageTimeStamp)
    }
    
    var isInitialized: Bool {
        return lastMessageTimeStamp != -1
    }
    
    // MARK: Convenience
    
    func setLastMessageLabel(message: Message?) {
        guard let message = message else {
            lastMessageLabel = ""
            return
        }

        let lastMessageText = message.text ?? ""
        switch message.messageType {
        case .text:
            lastMessageLabel = lastMessageText
        case .image:
            lastMessageLabel = "Photo ".localized + lastMessageText
        case .video:
            lastMessageLabel = "Video ".localized + lastMessageText
        case .voiceNote:
            lastMessageLabel = "VoiceNote".localized
        case .file:
            lastMessageLabel = "File".localized + lastMessageText
        case .location:
            lastMessageLabel = "Location".localized
        case .contact:
            lastMessageLabel = "Contact".localized
        case .interaction:
            lastMessageLabel = "Interacted on your message".localized
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(participantsIDs, forKey: .participantsIDs)
        try container.encode(messages!, forKey: .messages)
        try container.encode(groupChatImageUrl, forKey: .groupChatImageUrl)
      }
}

