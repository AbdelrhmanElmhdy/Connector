//
//  User+CoreDataProperties.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 03/10/2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var chatRoomIds: [String]?
    @NSManaged public var email: String
    @NSManaged public var firstName: String
    @NSManaged public var id: String
    @NSManaged public var imageUrl: URL?
    @NSManaged public var isCurrentUser: Bool
    @NSManaged public var lastName: String
    @NSManaged public var thumbnailImageUrl: URL?
    @NSManaged public var username: String
    @NSManaged public var chatRooms: NSSet?

}

// MARK: Generated accessors for chatRooms
extension User {

    @objc(addChatRoomsObject:)
    @NSManaged public func addToChatRooms(_ value: ChatRoom)

    @objc(removeChatRoomsObject:)
    @NSManaged public func removeFromChatRooms(_ value: ChatRoom)

    @objc(addChatRooms:)
    @NSManaged public func addToChatRooms(_ values: NSSet)

    @objc(removeChatRooms:)
    @NSManaged public func removeFromChatRooms(_ values: NSSet)

}

extension User : Identifiable {

}
