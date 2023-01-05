//
//  ChatRoom+CoreDataProperties.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 31/07/2022.
//
//

import Foundation
import CoreData


extension ChatRoom {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoom> {
		return NSFetchRequest<ChatRoom>(entityName: "ChatRoom")
	}
	
	@NSManaged public var groupChatImageUrl: String?
	@NSManaged public var groupChatName: String?
	@NSManaged public var id: String
	@NSManaged public var participantsIDs: [String]
	@NSManaged public var messages: Set<Message>?
	@NSManaged public var participants: Set<User>?
	@NSManaged public var lastMessageTimeStamp: Double
	@NSManaged public var lastMessageLabel: String
	
}

// MARK: Generated accessors for messages
extension ChatRoom {
	
	@objc(insertObject:inMessagesAtIndex:)
	@NSManaged public func insertIntoMessages(_ value: Message, at idx: Int)
	
	@objc(removeObjectFromMessagesAtIndex:)
	@NSManaged public func removeFromMessages(at idx: Int)
	
	@objc(insertMessages:atIndexes:)
	@NSManaged public func insertIntoMessages(_ values: [Message], at indexes: IndexSet)
	
	@objc(removeMessagesAtIndexes:)
	@NSManaged public func removeFromMessages(at indexes: IndexSet)
	
	@objc(replaceObjectInMessagesAtIndex:withObject:)
	@NSManaged public func replaceMessages(at idx: Int, with value: Message)
	
	@objc(replaceMessagesAtIndexes:withMessages:)
	@NSManaged public func replaceMessages(at indexes: IndexSet, with values: [Message])
	
	@objc(addMessagesObject:)
	@NSManaged public func addToMessages(_ value: Message)
	
	@objc(removeMessagesObject:)
	@NSManaged public func removeFromMessages(_ value: Message)
	
	@objc(addMessages:)
	@NSManaged public func addToMessages(_ values: Set<Message>)
	
	@objc(removeMessages:)
	@NSManaged public func removeFromMessages(_ values: Set<Message>)
	
}

// MARK: Generated accessors for participants
extension ChatRoom {
	
	@objc(addParticipantsObject:)
	@NSManaged public func addToParticipants(_ value: User)
	
	@objc(removeParticipantsObject:)
	@NSManaged public func removeFromParticipants(_ value: User)
	
	@objc(addParticipants:)
	@NSManaged public func addToParticipants(_ values: Set<User>)
	
	@objc(removeParticipants:)
	@NSManaged public func removeFromParticipants(_ values: Set<User>)
	
}

extension ChatRoom : Identifiable {
	
}
