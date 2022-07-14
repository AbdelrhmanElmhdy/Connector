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
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataError.decoderMissingManagedObjectContext(context: "trying to decode a json response into a Message object")
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.participantsIDs = try container.decode([UUID].self, forKey: .participantsIDs)
        self.groupChatImageUrl = try container.decode(String.self, forKey: .groupChatImageUrl)
        self.messages = try container.decode(Set<Message>.self, forKey: .messages) as NSSet
    }
    
    /// Describes whether or not this chat room is between only two persons
    var isChatBinary: Bool {
        return participantsIDs?.count == 2
    }
    
    /// The IDs of all the other partners in the chat room not including the current user's ID
    var partnersIDs: [UUID] {
        guard let user = UserDefaultsManager.user, let participantsIDs = participantsIDs else { return [] }
        
        return participantsIDs.filter { $0 != user.id }
    }
        
    var lastMessage: Message? {
        guard let messages = messages?.allObjects as? [Message] else {
            return nil
        }
        
        return messages.last
    }
    
    var lastMessageLabel: String? {
        switch lastMessage?.messageType {
        case .text:
            return lastMessage?.text
        case .image:
            return "Photo ".localized + (lastMessage?.text ?? "")
        case .video:
            return "Video ".localized + (lastMessage?.text ?? "")
        case .voiceNote:
            return "VoiceNote ".localized + (lastMessage?.text ?? "")
        case .file:
            return "File ".localized + (lastMessage?.text ?? "")
        case .location:
            return "Location ".localized + (lastMessage?.text ?? "")
        case .contact:
            return "Contact ".localized + (lastMessage?.text ?? "")
        case .interaction:
            return "Interacted on your message".localized
        case .none:
            return ""
        }
    }
    
    var chatImageURL: URL? {
        guard isChatBinary else { return URL(string: groupChatImageUrl ?? "") }
        
        let partnerID = partnersIDs[0]
        let partnerImageUrlString = User(id: partnerID).imageUrl
        
        return partnerImageUrlString
    }
    
    var lastMessageDate: Date? {
        return lastMessage?.sentDate
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(participantsIDs, forKey: .participantsIDs)
        try container.encode(messages as! Set<Message>, forKey: .messages)
        try container.encode(groupChatImageUrl, forKey: .groupChatImageUrl)
      }
        
}

