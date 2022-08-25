//
//  Message+CoreDataClass.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//
//

import Foundation
import CoreData
import FirebaseFirestore

@objc(Message)
public class Message: NSManagedObject, FirebaseCodable, Codable {
    enum MessageType: Int16 {
        case text
        case voiceNote
        case image
        case video
        case file
        case location
        case contact
        case interaction
    }
    
    enum InteractionType: Int16 {
        case love
        case like
        case haha
        case clap
        case sad
    }
    
    enum CodingKeys: CodingKey {
         case id, senderId, roomId, sentDateUnixTimeStamp, receiptDateUnixTimeStamp, repliedAtMessageId, type, text, mediaOrFileURL, location, contact, interactionType
     }
    
    required convenience init(context: NSManagedObjectContext, document: DocumentSnapshot) {
        self.init(context: context)
        
        guard let data = document.data() else { return }
        
        self.id = document.documentID
        self.senderId = data["senderId"] as? String
        self.roomId = data["roomId"] as? String
        self.sentDateUnixTimeStamp = data["sentDateUnixTimeStamp"] as? Double ?? -1
        self.receiptDateUnixTimeStamp = data["receiptDateUnixTimeStamp"] as? Double ?? -1
        self.repliedAtMessageId = data["repliedAtMessageId"] as? String
        self.type = data["type"] as? Int16 ?? 0
        self.text = data["text"] as? String
        self.mediaOrFileURL = data["mediaOrFileURL"] as? String
        self.interactionType = data["interactionType"] as? Int16 ?? 0
    }
    
    func encodeToDictionary() -> [String: Any?] {
        let dictionary: [String: Any?] = [
            "id": self.id,
            "senderId": self.senderId,
            "roomId": self.roomId,
            "sentDateUnixTimeStamp": self.sentDateUnixTimeStamp,
            "receiptDateUnixTimeStamp": self.receiptDateUnixTimeStamp,
            "repliedAtMessageId": self.repliedAtMessageId,
            "type": self.type,
            "text": self.text,
            "mediaOrFileURL": self.mediaOrFileURL,
            "interactionType": self.interactionType,
            "pendingFor": self.room?.participantsIDs?.filter {$0 != self.senderId}
        ]
        
        return dictionary
    }
    

    convenience init(
        senderId: String,
        roomId: String,
        repliedAtMessageId: String? = nil,
        type: MessageType,
        text: String? = nil,
        mediaOrFileURL: URL? = nil,
        location: Location? = nil,
        contact: Contact? = nil,
        interactionType: InteractionType? = nil
    ) {
        self.init(context: CoreDataManager.context)
        
        self.id = UUID().uuidString
        self.senderId = senderId
        self.roomId = roomId
        self.repliedAtMessageId = repliedAtMessageId
        self.type = type.rawValue
        self.text = text
        self.mediaOrFileURL = mediaOrFileURL?.absoluteString
        self.location = location
        self.contact = contact
        self.interactionType = interactionType?.rawValue ?? -1
        self.sentDate = Date.now
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataError.decoderMissingManagedObjectContext()
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.senderId = try container.decode(String.self, forKey: .senderId)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.sentDateUnixTimeStamp = try container.decode(Double.self, forKey: .sentDateUnixTimeStamp)
        self.receiptDateUnixTimeStamp = try container.decode(Double.self, forKey: .receiptDateUnixTimeStamp)
        self.repliedAtMessageId = try container.decode(String.self, forKey: .repliedAtMessageId)
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

        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(senderId, forKey: .senderId)
        try container.encodeIfPresent(roomId, forKey: .roomId)
        try container.encodeIfPresent(sentDateUnixTimeStamp, forKey: .sentDateUnixTimeStamp)
        try container.encodeIfPresent(receiptDateUnixTimeStamp, forKey: .receiptDateUnixTimeStamp)
        try container.encodeIfPresent(repliedAtMessageId, forKey: .repliedAtMessageId)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(mediaOrFileURL, forKey: .mediaOrFileURL)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(contact, forKey: .contact)
        try container.encodeIfPresent(interactionType, forKey: .interactionType)
      }
}
