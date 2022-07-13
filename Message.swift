//
//  Message+CoreDataClass.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject, Codable {
    
    enum MessageType: Int16 {
        case text = 0
        case voiceNote
        case image
        case video
        case file
        case location
        case contact
        case interaction
    }
    
    enum InteractionType: Int16 {
        case love = 0
        case like
        case haha
        case clap
        case sad
    }
    
    enum CodingKeys: CodingKey {
         case id, senderId, roomId, sentDateUnixTimeStamp, receiptDateUnixTimeStamp, repliedAtMessageId, type, text, mediaOrFileURL, location, contact, interactionType
     }

    convenience init(
        senderId: UUID,
        roomId: UUID,
        repliedAtMessageId: UUID? = nil,
        type: MessageType,
        text: String? = nil,
        mediaOrFileURL: URL? = nil,
        location: Location? = nil,
        contact: Contact? = nil,
        interactionType: InteractionType? = nil
    ) {
        self.init(context: CoreDataManager.context)
        
        self.id = UUID()
        self.senderId = senderId
        self.roomId = roomId
        self.repliedAtMessageId = repliedAtMessageId
        self.type = type.rawValue
        self.text = text
        self.mediaOrFileURL = mediaOrFileURL?.absoluteString
        self.location = location
        self.contact = contact
        self.interactionType = interactionType?.rawValue ?? -1
        
        do {
            self.room = try CoreDataManager.retrieveChatRoom(roomId: roomId)
        } catch {
            ErrorManager.reportError(error)
        }
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataError.decoderMissingManagedObjectContext(context: "trying to decode a json response into a Message object")
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.senderId = try container.decode(UUID.self, forKey: .senderId)
        self.roomId = try container.decode(UUID.self, forKey: .roomId)
        self.sentDateUnixTimeStamp = try container.decode(Double.self, forKey: .sentDateUnixTimeStamp)
        self.receiptDateUnixTimeStamp = try container.decode(Double.self, forKey: .receiptDateUnixTimeStamp)
        self.repliedAtMessageId = try container.decode(UUID.self, forKey: .repliedAtMessageId)
        self.type = try container.decode(Int16.self, forKey: .type)
        self.text = try container.decode(String.self, forKey: .text)
        self.mediaOrFileURL = try container.decode(String.self, forKey: .mediaOrFileURL)
        self.location = try container.decode(Location.self, forKey: .location)
        self.contact = try container.decode(Contact.self, forKey: .contact)
        self.interactionType = try container.decode(Int16.self, forKey: .interactionType)
    }
    
    
    var isIncoming: Bool {
        guard let user = UserDefaultsManager.user else { return false }
        return self.senderId != user.id
    }
    
    /// Describes whether or not the message has been successfully sent to server
    var isSent: Bool {
        return !isIncoming && sentDateUnixTimeStamp != -1
    }
    
    var sentDate: Date? {
        get {
            if sentDateUnixTimeStamp == -1 { return nil }
            return Date(timeIntervalSince1970: sentDateUnixTimeStamp)
        } set {
            guard let newValue = newValue else { return }
            sentDateUnixTimeStamp = newValue.timeIntervalSince1970
        }
    }
    
    var receiptDate: Date? {
        get {
            if sentDateUnixTimeStamp == -1 { return nil }
            return Date(timeIntervalSince1970: receiptDateUnixTimeStamp)
        } set {
            guard let newValue = newValue else { return }
            receiptDateUnixTimeStamp = newValue.timeIntervalSince1970
        }
    }
    
    var messageType: MessageType {
        return MessageType(rawValue: type)!
    }
        
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(roomId, forKey: .roomId)
        try container.encode(sentDateUnixTimeStamp, forKey: .sentDateUnixTimeStamp)
        try container.encode(receiptDateUnixTimeStamp, forKey: .receiptDateUnixTimeStamp)
        try container.encode(repliedAtMessageId, forKey: .repliedAtMessageId)
        try container.encode(type, forKey: .type)
        try container.encode(text, forKey: .text)
        try container.encode(mediaOrFileURL, forKey: .mediaOrFileURL)
        try container.encode(location, forKey: .location)
        try container.encode(contact, forKey: .contact)
        try container.encode(interactionType, forKey: .interactionType)
      }
}
