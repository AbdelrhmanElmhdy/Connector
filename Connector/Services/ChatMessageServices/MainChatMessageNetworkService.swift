//
//  MainChatMessageNetworkService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 05/10/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import CoreData

class MainChatMessageNetworkService: ChatMessageNetworkService {
	private let firebaseManager: FirebaseManagerProtocol
	
	private var currentUserId: String?
	private var messagesListener: ListenerRegistration?
	
	init(firebaseManager: FirebaseManagerProtocol) {
		self.firebaseManager = firebaseManager
	}
	
	func listenForIncomingMessages(completionHandler: @escaping (_ message: [Message]) -> Void, currentUserId: String, managedObjectContext: NSManagedObjectContext) {
		let query = firebaseManager.firestoreDB
			.collection("messages")
			.whereField("pendingFor", arrayContains: currentUserId)
		
		messagesListener = firebaseManager.addListener(to: query) { [self] querySnapshot, error in
			// Ignore update if it's initiated from the local client.
			let updateIsLocallyInitiated = querySnapshot?.metadata.hasPendingWrites ?? false
			guard !updateIsLocallyInitiated else { return }
			
			
			guard let documents = querySnapshot?.documents else {
				ErrorManager.shared.reportError("Error fetching message documents in incomingMessagesListener")
				return
			}
			
			removeCurrentUidFromListOfMessageReceivers(currentUid: currentUserId, documents: documents)
			
			let messages = documents.map { (document) -> Message? in
				let message = Message(document: document, context: managedObjectContext)
				message?.isIncoming = message?.senderId != currentUserId
				return message
			}.compactMap { $0 }
			
			completionHandler(messages)
		}
	}
	
	func removeCurrentUidFromListOfMessageReceivers(currentUid: String, documents: [DocumentSnapshot]) {
		for document in documents {
			guard let data = document.data() else { continue }
			let messageIsPendingFor = (data["pendingFor"] as? [String])?.filter { $0 != currentUid }
			document.reference.updateData(["pendingFor": messageIsPendingFor ?? []])
		}
	}
	
	func initializeChatRoom(_ room: ChatRoom, withMessage message: Message) {
		firebaseManager.firestoreDB.collection("chatRooms").document(room.id).setData([
			"participantsIDs": room.participantsIDs,
		])
		
		sendMessage(message: message)
	}
	
	func sendMessage(message: Message) {
		let messageDictionary = message.encodeToFirebaseData()
		
		firebaseManager.firestoreDB
			.collection("messages")
			.document(message.id!)
			.setData(messageDictionary)
	}
	
	func stopListeningForIncomingMessages() {
		messagesListener?.remove()
	}
}
