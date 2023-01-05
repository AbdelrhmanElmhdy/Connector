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
public class User: NSManagedObject, FirebaseCodableManagedObject, Codable {
	
	enum CodingKeys: CodingKey {
		case id, firstName, lastName, username, email, chatRoomIds, imageUrl, isCurrentUser, thumbnailImageUrl
	}
	
	var name: String {
		firstName + " " + lastName
	}
	
	required convenience public init(from decoder: Decoder) throws {
		guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
			throw DecodingError.failedToDecode(description: "No NSManagedObjectContext")
		}
		
		self.init(context: context)
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(String.self, forKey: .id)
		self.firstName = try container.decode(String.self, forKey: .firstName)
		self.lastName = try container.decode(String.self, forKey: .lastName)
		self.username = try container.decode(String.self, forKey: .username)
		self.email = try container.decode(String.self, forKey: .email)
		self.chatRoomIds = try container.decodeIfPresent([String].self, forKey: .chatRoomIds)
		self.imageUrl = try? container.decodeIfPresent(URL.self, forKey: .imageUrl)
		self.isCurrentUser = false
		self.thumbnailImageUrl = try? container.decodeIfPresent(URL.self, forKey: .thumbnailImageUrl)
	}
	
	required convenience init?(document: DocumentSnapshot?, context: NSManagedObjectContext) {
		self.init(context: context)
		
		guard let document = document,
					let data = document.data(),
					let firstName = data["firstName"] as? String,
					let lastName = data["lastName"] as? String,
					let username = data["username"] as? String,
					let email = data["email"] as? String else { return nil }
		
		self.id = document.documentID
		self.firstName = firstName
		self.lastName = lastName
		self.username = username
		self.email = email
		self.chatRoomIds = data["chatRoomIds"] as? [String]
		self.isCurrentUser = false
		
		let imageUrlString = data["imageUrl"] as? String ?? ""
		let thumbnailImageUrl = data["thumbnailImageUrl"] as? String ?? ""
		
		self.imageUrl = URL(string: imageUrlString)
		self.thumbnailImageUrl = URL(string: thumbnailImageUrl)
	}
	
	func encodeToFirebaseData() -> [String: Any] {
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
		
		return dictionary.compactMapValues { $0 }
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
