//
//  UserModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 18/04/2022.
//

import Foundation
import UIKit
import CoreData
import FirebaseFirestore

@objc(User)
public class User: NSManagedObject, FirebaseCodable, Codable {
        
    enum CodingKeys: CodingKey {
         case id, firstName, lastName, username, email, chatRoomIds, imageUrl, thumbnailImageUrl
     }
    
    var name: String {
        (firstName ?? "") + " " + (lastName ?? "")
    }
        
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.chatRoomIds = try container.decodeIfPresent([String].self, forKey: .chatRoomIds)
        self.imageUrl = try? container.decodeIfPresent(URL.self, forKey: .imageUrl)
        self.thumbnailImageUrl = try? container.decodeIfPresent(URL.self, forKey: .thumbnailImageUrl)
    }
        
    required convenience init(context: NSManagedObjectContext, document: DocumentSnapshot) {
        self.init(context: context)
        
        guard let data = document.data() else { return }
        
        self.id = document.documentID
        self.firstName = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
        self.username = data["username"] as? String
        self.email = data["email"] as? String
        self.chatRoomIds = data["chatRoomIds"] as? [String]
        
        let imageUrlString = data["imageUrl"] as? String ?? ""
        let thumbnailImageUrl = data["thumbnailImageUrl"] as? String ?? ""
        
        self.imageUrl = URL(string: imageUrlString)
        self.thumbnailImageUrl = URL(string: thumbnailImageUrl)
    }
    
    convenience init(id: String) {
        self.init(context: CoreDataManager.context)
        
        self.id = id
        firstName = ""
        lastName = ""
        username = ""
        email = ""
        chatRoomIds = []
        imageUrl = nil
        thumbnailImageUrl = nil
    }
    
    func encodeToDictionary() -> [String: Any?] {
        let dictionary: [String: Any?] = [
            "id": self.id,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "username": self.username,
            "email": self.email,
            "chatRoomIds": self.chatRoomIds,
            "imageUrl": self.imageUrl?.absoluteString,
            "thumbnailImageUrl": self.thumbnailImageUrl?.absoluteString,
        ]
        
        return dictionary
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(chatRoomIds, forKey: .chatRoomIds)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(thumbnailImageUrl, forKey: .thumbnailImageUrl)
    }
}
