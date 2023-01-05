//
//  ChatMessageNetworkService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/12/2022.
//

import Foundation
import CoreData
import FirebaseCore
import FirebaseFirestore

protocol ChatMessageNetworkService: AutoMockable {
	func listenForIncomingMessages(completionHandler: @escaping (_ message: [Message]) -> Void, currentUserId: String, managedObjectContext: NSManagedObjectContext)
	
	func removeCurrentUidFromListOfMessageReceivers(currentUid: String, documents: [DocumentSnapshot])
	
	func initializeChatRoom(_ room: ChatRoom, withMessage message: Message)
	
	func sendMessage(message: Message)
	
	func stopListeningForIncomingMessages()
}
